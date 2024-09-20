# output "number_of_worker_machines" {
#     description = "number_of_worker_machines"
#     value = var.number_of_worker_machines
# }
#
# output "nodes_instance_ids" {
#   description = "List of instance IDs to register in the target group"
#   value       = aws_instance.worker_node[*].id
# }
#
# output "control_plane_id" {
#   description = "List of instance IDs to register in the target group"
#   value       = aws_instance.control_plane[*].id
# }
#
# output "public_key_name" {
#     description = "public_key_name"
#     value       = var.public_key_name
# }
#
# output "public_subnet_ids" {
#     description = "public_subnet_ids"
#     value       = var.public_subnet_ids
# }
#
# output "env" {
#   description = "Environment"
#   value       = var.env
# }