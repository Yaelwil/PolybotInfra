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

output "bucket_arn_dev" {
  description = "bucket_arn"
  value        = var.bucket_arn_dev
}

output "bucket_arn_prod" {
  description = "bucket_arn_prod"
  value        = var.bucket_arn_prod
}


#################
# DynamoDB vars #
#################

output "dynamodb_table_arn_dev" {
  description = "dynamodb_table_arn_dev"
  value        = var.dynamodb_table_arn_dev
}

output "dynamodb_table_arn_prod" {
  description = "dynamodb_table_arn_prod"
  value        = var.dynamodb_table_arn_prod
}

############
# SQS vars #
############

output "yolov5_sqs_queue_arn_dev" {
  description = "yolov5_sqs_queue_arn_dev"
  value        = var.yolov5_sqs_queue_arn_dev
}

output "filters_sqs_queue_arn_dev" {
  description = "filters_sqs_queue_arn_dev"
  value        = var.filters_sqs_queue_arn_dev
}

output "yolov5_sqs_queue_arn_prod" {
  description = "yolov5_sqs_queue_arn_prod"
  value        = var.yolov5_sqs_queue_arn_prod
}

output "filters_sqs_queue_arn_prod" {
  description = "filters_sqs_queue_arn_prod"
  value        = var.filters_sqs_queue_arn_prod
}

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