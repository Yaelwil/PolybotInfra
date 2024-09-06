#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Variables (Customize these as needed)
EC2_USER="ubuntu"
SSH_KEY_PATH="~/yaelwil_k8s_project.pem"
CLUSTER_NAME="yaelwil-cluster-k8s"
REMOTE_CLUSTER_CONFIG_DIRECTORY="~/"
REMOTE_CLUSTER_CONFIG_PATH="~/cluster-configs.yaml"
EBS_CSI_VALUES_DIRECTORY="~/"
EBS_CSI_VALUES_PATH="~/ebs-csi-values.yaml"
REGION="eu-west-1"

##########################
# Fetch Control Plane IP #
##########################

EC2_CONTROL_PLANE=$(aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=tag:Name,Values=*control-plane*" "Name=tag:Name,Values=*yaelwil*" "Name=tag:Name,Values=*k8s-project*" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output json)

# Extract Control Plane IPs
CONTROL_PLANE_IPS=$(echo "$EC2_CONTROL_PLANE" | jq -r '.[][] | select(.[1] == "running") | .[2]')

# Check if any control plane IPs were found
if [ -z "$CONTROL_PLANE_IPS" ]; then
  echo -e "${RED}No control plane was found.${NC}"
  exit 1
fi

# Print Control Plane IPs
echo -e "${GREEN}Control Plane IP(s):${NC} $CONTROL_PLANE_IPS"

########################
# Fetch Worker Node IP #
########################

EC2_WORKER_NODES=$(aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=tag:Name,Values=*worker-node*" "Name=tag:Name,Values=*yaelwil*" "Name=tag:Name,Values=*k8s-project*" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output json)

# Extract Worker Node IPs
WORKER_NODE_IPS=$(echo "$EC2_WORKER_NODES" | jq -r '.[][] | select(.[1] == "running") | .[2]')

# Check if any worker nodes were found
if [ -z "$WORKER_NODE_IPS" ]; then
  echo -e "${RED}No worker nodes were found.${NC}"
  exit 1
fi

# Print Worker Node IPs
echo -e "${GREEN}Worker Node IP(s):${NC} $WORKER_NODE_IPS"

##########################
# Step 1: Initialize the Control Plane Node #
##########################

# Create the cluster-configs.yaml locally
cat <<EOF > /tmp/cluster-configs.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
clusterName: $CLUSTER_NAME
apiServer:
  extraArgs:
    cloud-provider: external
    allow-privileged: "true"
controllerManager:
  extraArgs:
    cloud-provider: external
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
EOF

# Iterate over Control Plane IPs
for CONTROL_PLANE_IP in $CONTROL_PLANE_IPS; do
  # Copy the cluster configuration file to the Control Plane node
  scp -i $SSH_KEY_PATH /tmp/cluster-configs.yaml $EC2_USER@$CONTROL_PLANE_IP:$REMOTE_CLUSTER_CONFIG_DIRECTORY
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Copied the file to the control plane ($CONTROL_PLANE_IP) successfully.${NC}"
  else
    echo -e "${RED}Failed to copy the file to the control plane ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi

  # Connect to the Control Plane node and perform initialization
  ssh -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << EOF
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Initialize the Kubernetes cluster using kubeadm
    sudo kubeadm init --config $REMOTE_CLUSTER_CONFIG_PATH

    # Set up kubeconfig for kubectl
    mkdir -p \$HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config
    sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config

    # Install Flannel CNI plugin
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

    # Install AWS Cloud Controller Manager
    kubectl apply -k 'github.com/kubernetes/cloud-provider-aws/examples/existing-cluster/base/?ref=master'
EOF

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Control Plane node initialization completed successfully ($CONTROL_PLANE_IP).${NC}"
  else
    echo -e "${RED}Control Plane node initialization failed ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi
done

# Clean up the local cluster config file
rm /tmp/cluster-configs.yaml

##########################
# Step 2: Join Worker Nodes #
##########################

# Iterate over Worker Node IPs
for WORKER_NODE_IP in $WORKER_NODE_IPS; do
  # Get the join command from the Control Plane node
  JOIN_COMMAND=$(ssh -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" "kubeadm token create --print-join-command")

  # Connect to the Worker Node and perform the join
  ssh -i "$SSH_KEY_PATH" "$EC2_USER@$WORKER_NODE_IP" "sudo $JOIN_COMMAND"

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Worker Node joined successfully ($WORKER_NODE_IP).${NC}"
  else
    echo -e "${RED}Failed to join the Worker Node ($WORKER_NODE_IP).${NC}"
    exit 1
  fi
done

# Verify that the Worker Nodes joined successfully
ssh -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" "kubectl get nodes"

##########################
# Step 3: Install the EBS CSI Driver #
##########################

# Create the ebs-csi-values.yaml locally
cat <<EOF > /tmp/ebs-csi-values.yaml
storageClasses:
  - name: ebs-sc
    annotations:
      storageclass.kubernetes.io/is-default-class: "true"
    provisioner: ebs.csi.aws.com
    volumeBindingMode: WaitForFirstConsumer
    parameters:
      csi.storage.k8s.io/fstype: xfs
      type: gp2
      encrypted: "true"
EOF

# Iterate over Control Plane IPs to copy the EBS CSI driver values file
for CONTROL_PLANE_IP in $CONTROL_PLANE_IPS; do
  scp -i "$SSH_KEY_PATH" /tmp/ebs-csi-values.yaml "$EC2_USER@$CONTROL_PLANE_IP:$EBS_CSI_VALUES_DIRECTORY"

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Copied the EBS CSI driver values file to the Control Plane node ($CONTROL_PLANE_IP) successfully.${NC}"
  else
    echo -e "${RED}Failed to copy the EBS CSI driver values file to the Control Plane node ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi

  # Connect to the Control Plane node and install the EBS CSI driver using Helm
  ssh -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << EOF
    # Add the AWS EBS CSI Driver Helm repository
    helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
    helm repo update

    # Install the AWS EBS CSI Driver
    helm upgrade --install aws-ebs-csi-driver -f $EBS_CSI_VALUES_PATH -n kube-system aws-ebs-csi-driver/aws-ebs-csi-driver
EOF

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}EBS CSI driver installed successfully on Control Plane node ($CONTROL_PLANE_IP).${NC}"
  else
    echo -e "${RED}Failed to install the EBS CSI driver on Control Plane node ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi
done

# Clean up the local EBS CSI values file
rm /tmp/ebs-csi-values.yaml