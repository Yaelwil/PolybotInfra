#############
# Main vars #
#############
output "owner" {
  description = "Owner of the infrastructure"
  value       = var.owner
}

output "project" {
  description = "project name"
  value       = var.project
}

output "region" {
  description = "region"
  value       = var.region
}

#############
# VPC vars #
#############

output "main_vpc_cidr" {
  description = "main_vpc_cidr"
  value       = var.main_vpc_cidr
}


###############
# Bucket vars #
###############

output "bucket_arn" {
  description = "bucket_arn"
  value        = var.bucket_arn
}



#################
# DynamoDB vars #
#################

output "dynamodb_table_arn" {
  description = "dynamodb_table_arn"
  value        = var.dynamodb_table_arn
}

############
# SQS vars #
############

output "yolov5_sqs_queue_arn" {
  description = "yolov5_sqs_queue_arn"
  value        = var.yolov5_sqs_queue_arn
}

output "filters_sqs_queue_arn" {
  description = "filters_sqs_queue_arn"
  value        = var.filters_sqs_queue_arn
}

############
# SQS vars #
############

output "control_plane_role_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_role.control_plane_role.name
}

output "worker_nodes_role_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_role.worker_nodes_role.name
}

output "control_plane_instance_profile" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_instance_profile.control_plane_instance_profile.name
}

output "worker_nodes_instance_profile" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_instance_profile.worker_node_instance_profile.name
}

output "env" {
  description = "Environment"
  value       = var.env
}