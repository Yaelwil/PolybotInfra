#############
# Main vars #
#############
variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
}

variable "project" {
  description = "project name"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

#############
# VPC vars #
#############

variable "main_vpc_cidr" {
  description = "main_vpc_cidr"
  type        = string
}

###############
# Bucket vars #
###############

variable "bucket_arn_dev" {
  description = "bucket_arn"
  type        = string
}

variable "bucket_arn_prod" {
  description = "bucket_arn"
  type        = string
}

#################
# DynamoDB vars #
#################

variable "dynamodb_table_arn_dev" {
  description = "dynamodb_table_arn"
  type        = string
}

variable "dynamodb_table_arn_prod" {
  description = "dynamodb_table_arn"
  type        = string
}

############
# SQS vars #
############

variable "yolov5_sqs_queue_arn_dev" {
  description = "yolov5_sqs_queue_arn_dev"
  type        = string
}

variable "filters_sqs_queue_arn_dev" {
  description = "filters_sqs_queue_arn_dev"
  type        = string
}

variable "yolov5_sqs_queue_arn_prod" {
  description = "yolov5_sqs_queue_arn_prod"
  type        = string
}

variable "filters_sqs_queue_arn_prod" {
  description = "filters_sqs_queue_arn_prod"
  type        = string
}