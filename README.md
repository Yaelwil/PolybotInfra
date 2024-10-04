# K8S Project

In this project I utilize the modules I have made in the previous project (Terraform project) and create a fully K8S self-made cluster in 2 environment (Dev + Prod) using the same 3 EC2 instances (1 Control plane + 2 worker node).  
(Terraform project https://github.com/Yaelwil/INTPolybotServiceAWS)


I have 4 steps to complete and 1 is optional-

## 1. Fully self-made k8s cluster:  
- Manually provision a Kubernetes cluster with one control plane node and two worker nodes using Terraform and kubeadm. 
- The nodes will run on Ubuntu and utilize CRI-O as the container runtime instead of Docker. 
- Using terraform I created VPC, 2 Subnets, 3 EC2 instances (1 control plane + 2 worker nodes), 4 SQS Queues, 2 DynamoDB tables, Secrets Manager, 2 S3 Buckets, IAM Roles & Policies, Security Groups & ACLs and 2 Self-Signed Certificates.

## 2. Service Deployment:  
- Deployed the Polybot, Yolo, and Filters microservices in both Development and Production environments, ensuring logical separation using different namespaces and AWS resources. 
- Using K8S Yamls I created LB (Ingress controller), Polybot pod, Yolo pod, Filters pod, configmap for each environment and microservice pod.

## 3. CI/CD Pipelines:
Designed and implemented end-to-end CI/CD pipelines for multi-environment deployments using tools such as Jenkins, GitHub Actions, and ArgoCD.
  - Infrastructure Setup:  
  Automated the setup of Terraform infrastructure and Kubernetes cluster configuration, including the generation of TLS secrets for Ingress connections, file management, and environment-specific customization.
  - Branch-Specific Pipelines:  
  Developed branch-based CI pipelines in Jenkins, running tests (where applicable), and automating updates to YAML manifests for seamless deployment.
  - ArgoCD Integration:  
  Established ArgoCD pipelines to continuously sync cluster state with YAML manifests, ensuring automated and version-controlled Kubernetes deployments.

## 4. Monitoring:
- Logs:
  - Fluent Bit:  
    A lightweight log processor and forwarder that collects logs from various sources, including containers and files, and sends them to multiple outputs for storage and analysis. Deployed as a DaemonSet, Fluent Bit collects logs from all pods in the Kubernetes cluster.
  - Elasticsearch:  
    A distributed search and analytics engine that stores logs collected by Fluent Bit, making them searchable and analyzable. Fluent Bit sends logs to Elasticsearch for indexing and retrieval.
  - Kibana:  
    Kibana is a visualization tool that works with Elasticsearch. It provides an interface to search, view, and analyze the logs stored in Elasticsearch.
- Metrics:
  - Prometheus:  
    A powerful monitoring and alerting toolkit that collects and stores metrics as time series data. Prometheus scrapes metrics from various endpoints within the Kubernetes cluster, such as application pods, kubelets, and the API server, to gather performance data.
  - Grafana:  
    In addition to log visualization, Grafana is utilized to visualize metrics data collected by Prometheus. Users can create dashboards to monitor application performance, resource usage, and overall cluster health in real-time.
- Summary:  
  - Logs:  
    Fluent Bit → Collects logs from Kubernetes pods.  
    Elasticsearch → Stores logs for indexing and search.  
    Kibana → Visualizes and analyzes logs.
  - Metrics:  
    Prometheus → Collects and stores metrics data from the cluster.  
    Grafana → Visualizes and dashboards metrics data.


## 5. Autoscaling (Optional): 
Implemented the Cluster Autoscaler for dynamic scaling of worker nodes based on resource demands, with required configurations in Terraform.

## Related repositories-
- Polybot Microservice repo- https://github.com/Yaelwil/PolybotMicroservice
- Yolo Microservice repo- https://github.com/Yaelwil/YoloMicroservice
- Filters Microservice repo- https://github.com/Yaelwil/FiltersMicroservice
