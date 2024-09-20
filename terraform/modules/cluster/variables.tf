variable "k8s_version" {
    description = "The version of Kubernetes to deploy. Defaults to v1.30."
    type = string
    default = "v1.30"
}

variable "vpc_id" {
    description = "vpc_id"
    type = string
}

variable "control_plane_iam_role" {
    description = "control_plane_iam_role"
    type = string
}

variable "worker_node_iam_role" {
    description = "worker_node_iam_role"
    type = string
}

variable "public_subnet_ids" {
    description = "public_subnet_ids"
    type = list(string)
}

variable "number_of_worker_machines" {
    description = "number_of_worker_machines"
    type = string
}

variable "ubuntu_ami" {
    description = "ubuntu_ami"
    type = string
}

variable "instance_type" {
    description = "instance_type"
    type = string
}

variable "public_key_name" {
    description = "public_key_name"
    type = string
}

variable "cluster_name" {
    description = "cluster_name"
    type = string
}

variable "project_name" {
    description = "project_name"
    type = string
}

variable "region" {
    description = "region"
    type = string
}

variable "owner_name" {
    description = "owner_name"
    type = string
}

variable "env" {
  type = string
  description = "Environment"
}