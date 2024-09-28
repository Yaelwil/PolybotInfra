# K8S Project

In this project I utilize the modules I have made in the previous project (Terraform project) and create a fully K8S self made cluster in 2 enviournment (Dev + Prod) using the same 2 EC2 instances (Control plane + worker node).  
(Terraform project https://github.com/Yaelwil/INTPolybotServiceAWS)


I have 4 steps to complete and 1 is optional-

- Fully self made k8s cluster-  
  - Manually provision a Kubernetes cluster with one control plane node and one worker node using Terraform and kubeadm. 
  - The nodes will run on Ubuntu and utilize CRI-O as the container runtime instead of Docker. 
  - Using terraform I created VPC, 2 Subnets, 2 EC2 instances (control plane + worker node), 4 SQS Queues, 2 DynamoDB tables, Secrets Manager, 2 S3 Buckets, IAM Roles & Policies, Security Groups & ACLs and 2 Self-Signed Certificates.

- Service Deployment-  
  - Deployed the Polybot, Yolo, and Filters microservices in both Development and Production environments, ensuring logical separation using different namespaces and AWS resources. 
  - Using K8S Yamls I created LB (Ingress controller), Polybot pod, Yolo pod, Filters pod, configmap for each environment and microservice pod.

- CI/CD Pipelines:
  - Implemented CI/CD pipelines for both environments, utilizing tools like Jenkins or GitHub Actions, and managed continuous deployment with ArgoCD for all YAML manifests. 
    - First, I created a complete CI/CD process that sets up the Terraform infrastructure, applies K8S cluster configurations, creates and copies necessary files, and generates TLS secrets for ingress connections. 
    - Second, I established a Jenkins CI/CD pipeline for each branch that runs tests (if applicable) and updates the YAML manifests accordingly. 
    - Third, I plan to create an ArgoCD pipeline.

- Monitoring:
Set up a monitoring stack using Prometheus for metrics collection, a log aggregation solution (such as ELK or EFK), and Grafana for visualization of metrics and logs.

- Autoscaling (Optional): 
Implemented the Cluster Autoscaler for dynamic scaling of worker nodes based on resource demands, with required configurations in Terraform.

## Related repositories-
- Polybot Microservice repo- https://github.com/Yaelwil/PolybotMicroservice
- Yolo Microservice repo- https://github.com/Yaelwil/YoloMicroservice
- Filters Microservice repo- https://github.com/Yaelwil/FiltersMicroservice