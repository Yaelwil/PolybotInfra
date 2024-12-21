# K8S Project

In this project I utilize the modules I have made in the previous project (Terraform project) and create a fully K8S self-made cluster in 2 environment (Dev + Prod) using the same 3 EC2 instances (1 Control plane + 2 worker node + 1 for jenkins pipelines).  
(Terraform project https://github.com/Yaelwil/INTPolybotServiceAWS)

## 1. Fully self-made k8s cluster
- Manually provision a Kubernetes cluster with one control plane node and two worker nodes using Terraform and kubeadm. 
- The nodes will run on Ubuntu and utilize CRI-O as the container runtime instead of Docker. 
- Using terraform I created VPC, 2 Subnets, 3 EC2 instances (1 control plane + 2 worker nodes), 4 SQS Queues, 2 DynamoDB tables, Secrets Manager, 2 S3 Buckets, IAM Roles & Policies, Security Groups & ACLs and 2 Self-Signed Certificates.  
Terraform explanation link: [Terraform](documentation/Terraform_README.md)


## 2. Service Deployment 
- Deployed the Polybot, Yolo, and Filters microservices in both Development and Production environments, ensuring logical separation using different namespaces and AWS resources. 
- Using K8S Yamls I created LB (Ingress controller), Polybot pod, Yolo pod, Filters pod, configmap for each environment and microservice pod.  
Kubernetes explanation link: [Kubernetes](documentation/K8S_README.md)

## 3. CI/CD Pipelines
Designed and implemented end-to-end CI/CD pipelines for multi-environment deployments using tools such as Jenkins, GitHub Actions, and ArgoCD.
  - Infrastructure Setup (GitHub Actions):  
  Automated the setup of Terraform infrastructure and Kubernetes cluster configuration, including the generation of TLS secrets for Ingress connections, file management, and environment-specific customization.
  - Branch-Specific Pipelines (Jenkins):  
  Developed branch-based CI pipelines in Jenkins, running tests (where applicable), and automating updates to YAML manifests for seamless deployment.
  - ArgoCD Integration:  
  Established ArgoCD pipelines to continuously sync cluster state with YAML manifests, ensuring automated and version-controlled Kubernetes deployments.  
GitHub actions, Jenkins and ArgoCD explanation link: [GitHub_Actions_Jenkins_ArgoCD](documentation/GHA_Jen_ArgoCD_README.md)

## 4. Monitoring
This part of the project focuses on implementing service monitoring for a Kubernetes-based infrastructure.  
It aims to provide observability by setting up a metrics collection and logs aggregation stack, along with a Kibana or Grafana server for visualization.  
This helps in monitoring the health, performance, and resource usage of various services running in the cluster.  
The solution includes tools such as Prometheus for collecting metrics, FluentBit for log aggregation, and Kibana or Grafana for creating dashboards.  
Monitoring explanation link: [Monitoring](documentation/Monitoring.MD)

## Related repositories-
- Polybot Microservice repo- https://github.com/Yaelwil/PolybotMicroservice
- Yolo Microservice repo- https://github.com/Yaelwil/YoloMicroservice
- Filters Microservice repo- https://github.com/Yaelwil/FiltersMicroservice
