#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Variables (Customize these as needed)
EC2_USER="ubuntu"
CLUSTER_NAME="yaelwil-cluster-k8s"
REMOTE_CLUSTER_CONFIG_DIRECTORY="~/"
REMOTE_CLUSTER_CONFIG_PATH="~/cluster-configs.yaml"
EBS_CSI_VALUES_DIRECTORY="~/"
EBS_CSI_VALUES_PATH="~/ebs-csi-values.yaml"

##########################
# Fetch Control Plane IP #
##########################

EC2_CONTROL_PLANE=$(aws ec2 describe-instances --region "$REGION" \
    --filters "Name=tag:Name,Values=*control-plane*" \
              "Name=tag:Name,Values=*yaelwil*" \
              "Name=tag:Name,Values=*k8s-project*" \
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

EC2_WORKER_NODES=$(aws ec2 describe-instances --region "$REGION" \
    --filters "Name=tag:Name,Values=*worker-node*" \
              "Name=tag:Name,Values=*yaelwil*" \
              "Name=tag:Name,Values=*k8s-project*" \
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

################################################################
# Save the SSH private key from the secret to a temporary file #
################################################################

# Define the path for the SSH key
SSH_KEY_PATH="./SSH_KEY_PATH.pem"

# Create an empty file or ensure the file exists
touch "$SSH_KEY_PATH"

# Save the SSH private key from the secret to the file
echo "$SSH_PRIVATE_KEY" > "$SSH_KEY_PATH"

# Ensure the SSH key file exists before setting permissions
if [ -z "$SSH_PRIVATE_KEY" ]; then
  echo "Error: SSH_PRIVATE_KEY is not set"
  exit 1
fi

# Set the proper permissions for the SSH key
chmod 400 "$SSH_KEY_PATH"

# Confirm the SSH key path
echo "SSH key saved at: $SSH_KEY_PATH"

#############################################
# Step 1: Initialize the Control Plane Node #
#############################################

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
  scp -o StrictHostKeyChecking=no -i $SSH_KEY_PATH /tmp/cluster-configs.yaml $EC2_USER@$CONTROL_PLANE_IP:$REMOTE_CLUSTER_CONFIG_DIRECTORY
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Copied the file to the control plane ($CONTROL_PLANE_IP) successfully.${NC}"
  else
    echo -e "${RED}Failed to copy the file to the control plane ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi

# Run the kubeadm init command on the remote machine and capture the output
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" "sudo kubeadm init --config $REMOTE_CLUSTER_CONFIG_PATH" | tee kubeadm-init-output.txt

# Extract the 'kubeadm join' command from the output
COMMAND_TO_JOIN=$(grep -A 2 "kubeadm join" kubeadm-init-output.txt | tr -d '\n' | sed 's/\\//g')

# Check if the command was found and display it
if [ -n "$COMMAND_TO_JOIN" ]; then
  echo -e "COMMAND_TO_JOIN: ${GREEN}$COMMAND_TO_JOIN${NC}"
else
  echo -e "${RED}Didn't get command to join.${NC}"
  exit 1
fi

#############################
# Step 2: Set up kubeconfig #
#############################

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << 'EOF'
# Create .kube directory
mkdir -p $HOME/.kube

# Copy the Kubernetes admin configuration file
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Change ownership of the configuration file
sudo chown $(id -u):$(id -g) $HOME/.kube/config
EOF

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Setup completed${NC}"
else
  echo -e "${RED}Setup not completed${NC}"
  exit 1
fi

#############################
# Step 3: Join Worker Nodes #
#############################

# Iterate over Worker Node IPs
for WORKER_NODE_IP in $WORKER_NODE_IPS; do

  # Connect to the Worker Node and perform the join
  ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$WORKER_NODE_IP" "sudo $COMMAND_TO_JOIN"

# Verify that the Worker Nodes joined successfully
ssh -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" "kubectl get nodes"

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Worker Node joined successfully ($WORKER_NODE_IP).${NC}"
  else
    echo -e "${RED}Failed to join the Worker Node ($WORKER_NODE_IP).${NC}"
    exit 1
  fi
done
done

#############################################################
# Step 4: Install Calico and AWS Cloud Controller Manager  #
#############################################################

  # Connect to the Control Plane node and perform initialization
  ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << EOF
    # Install Flannel CNI plugin
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/calico.yaml

    # Install AWS Cloud Controller Manager
    kubectl apply -k 'github.com/kubernetes/cloud-provider-aws/examples/existing-cluster/base/?ref=master'
EOF

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Calico and AWS Cloud Controller Manager was installed ($CONTROL_PLANE_IP).${NC}"
  else
    echo -e "${RED}Calico and AWS Cloud Controller Manager wasn't installed ($CONTROL_PLANE_IP).${NC}"
    exit 1
  fi

############################
# Clean unnecessary files  #
############################

rm /tmp/cluster-configs.yaml
rm ./kubeadm-init-output.txt

######################################
# Step 5: Install the EBS CSI Driver #
######################################

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
  scp -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" /tmp/ebs-csi-values.yaml "$EC2_USER@$CONTROL_PLANE_IP:$EBS_CSI_VALUES_DIRECTORY"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Copied the EBS CSI driver values file to the Control Plane node ($CONTROL_PLANE_IP) successfully.${NC}"
else
  echo -e "${RED}Failed to copy the EBS CSI driver values file to the Control Plane node ($CONTROL_PLANE_IP).${NC}"
  exit 1
fi

  # Connect to the Control Plane node and install the EBS CSI driver using Helm
  ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << EOF
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

############################
# Clean unnecessary files #
############################

rm /tmp/ebs-csi-values.yaml

####################################
# Install K8S dashboard and ArgoCD #
####################################

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << EOF

  kubectl create namespace kubernetes-dashboard || true
  # Add kubernetes-dashboard repository
  helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
  # Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
  helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

  # Install ArgoCD
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

  # Automatically approve and install Python and pip
  sudo apt update
  sudo apt install -y python3 python3-venv

  # Create a virtual environment
  python3 -m venv myenv
  source myenv/bin/activate

  # Install necessary Python packages
  pip install boto3 kubernetes
EOF

if [ $? -eq 0 ]; then
  echo -e "${GREEN}K8S dashboard, ArgoCD and Python packages were installed${NC}"
else
  echo -e "${RED}K8S dashboard, ArgoCD and Python packages weren't installed${NC}"
  exit 1
fi

######################################################################
# Install Fluent-bit, Elastic Search, kibana, Prometheus and Grafana #
######################################################################

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$EC2_USER@$CONTROL_PLANE_IP" << 'EOF'
  echo "Installing monitoring tools..."

  # Create or overwrite fluent-values.yaml
  cat <<FLUENT_CONF > fluent-values.yaml
  env:
    - name: ELASTIC_URL
      value: quickstart-es-http   # TODO change according to your elastic service address
    - name: ES_USER
      value: elastic
    - name: ES_PASSWORD
      valueFrom:
        secretKeyRef:
          name: quickstart-es-elastic-user
          key: elastic

  config:
    outputs: |
      [OUTPUT]
          Name es
          Match kube.*
          Host \${ELASTIC_URL}
          HTTP_User \${ES_USER}
          HTTP_Passwd \${ES_PASSWORD}
          Suppress_Type_Name On
          Logstash_Format On
          Retry_Limit False
          tls On
          tls.verify Off
          Replace_Dots On

      [OUTPUT]
          Name es
          Match host.*
          Host \${ELASTIC_URL}
          HTTP_User \${ES_USER}
          HTTP_Passwd \${ES_PASSWORD}
          Suppress_Type_Name On
          Logstash_Format On
          Logstash_Prefix node
          Retry_Limit False
          tls On
          tls.verify Off
          Replace_Dots On
FLUENT_CONF

  # Add the Fluent Helm repo
  helm repo add fluent https://fluent.github.io/helm-charts

  # Update the Helm repository to make sure we have the latest charts
  helm repo update

  # Install or upgrade Fluent Bit with the custom configuration
  helm upgrade --install fluent-bit fluent/fluent-bit -f fluent-values.yaml


  # Install elastic search
  kubectl create -f https://download.elastic.co/downloads/eck/2.13.0/crds.yaml
  kubectl apply -f https://download.elastic.co/downloads/eck/2.13.0/operator.yaml

  cat <<ES_CONF | kubectl apply -f -
  apiVersion: elasticsearch.k8s.elastic.co/v1
  kind: Elasticsearch
  metadata:
    name: quickstart
  spec:
    version: 8.15.2
    nodeSets:
    - name: default
      count: 1
      config:
        node.store.allow_mmap: false
ES_CONF

  # Install Kibana
  cat <<KIBANA_CONF | kubectl apply -f -
  apiVersion: kibana.k8s.elastic.co/v1
  kind: Kibana
  metadata:
    name: quickstart
  spec:
    version: 8.15.2
    count: 1
    elasticsearchRef:
      name: quickstart
KIBANA_CONF

  # Ensure the 'monitoring' namespace exists
  kubectl create namespace monitoring || echo "Namespace 'monitoring' already exists"

  # Add the Prometheus Helm chart repository
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

  # Add the Grafana Helm chart repository
  helm repo add grafana https://grafana.github.io/helm-charts

  # Update the repositories to make sure you have the latest version of the charts
  helm repo update

  # Install Prometheus using Helm in the 'monitoring' namespace
  helm install prometheus prometheus-community/prometheus --namespace monitoring

  # Install Grafana using Helm in the 'monitoring' namespace
  helm install grafana grafana/grafana --namespace monitoring
EOF


if [ $? -eq 0 ]; then
  echo -e "${GREEN}Fluent-bit, Elastic Search, kibana, Prometheus and Grafana were installed${NC}"
else
  echo -e "${RED}Fluent-bit, Elastic Search, kibana, Prometheus and Grafana weren't installed${NC}"
  exit 1
fi
done
