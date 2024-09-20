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

variable "bucket_arn" {
  description = "bucket_arn"
  type        = string
}

#################
# DynamoDB vars #
#################

variable "dynamodb_table_arn" {
  description = "dynamodb_table_arn"
  type        = string
}

############
# SQS vars #
############

variable "yolov5_sqs_queue_arn" {
  description = "yolov5_sqs_queue_arn"
  type        = string
}

variable "filters_sqs_queue_arn" {
  description = "filters_sqs_queue_arn"
  type        = string
}

variable "env" {
  type = string
  description = "Environment"
}