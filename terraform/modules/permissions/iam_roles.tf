# resource "aws_iam_role" "control_plane_role" {
#   name               = "${var.owner}-control-plane-role-${var.env}-${var.region}-${var.project}"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action    = "sts:AssumeRole"
#       }
#     ]
#   })
#
#   tags = {
#     Name      = "${var.owner}-control-plane-role-${var.env}-${var.region}-${var.project}"
#     Terraform = "true"
#   }
# }
#
# resource "aws_iam_role" "worker_nodes_role" {
#   name               = "${var.owner}-worker-nodes-role-${var.env}-${var.region}-${var.project}"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action    = "sts:AssumeRole"
#       }
#     ]
#   })
#
#   tags = {
#     Name      = "${var.owner}-worker-nodes-role-${var.env}-${var.region}-${var.project}"
#     Terraform = "true"
#   }
# }
#
# resource "aws_iam_role" "pod_role" {
#   name = "${var.owner}-pod-role-${var.env}-${var.region}-${var.project}"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "eks.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
#     tags = {
#     Name      = "${var.owner}-pod-role-${var.env}-${var.region}-${var.project}"
#     Terraform = "true"
#   }
# }
