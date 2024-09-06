/*
 The provider block configures the specified provider, in this case aws.
 You can use multiple provider blocks in your Terraform configuration to manage resources from different providers.
*/
provider "aws" {
  region  = var.region
}

provider "kubernetes" {
  version = "~> 2.11" # Replace this with the specific version you want
  config_path = "~/.kube/config" # Path to your kubeconfig file
}