# module "vpc" {
#   source = "./modules/vpc"
#
#   owner              = var.owner_name
#   project            = var.project_name
#   main_vpc_cidr      = var.main_vpc_cidr
#   public_subnet_1    = var.public_subnet_1
#   public_subnet_2    = var.public_subnet_2
#   availability_zone_1 = var.availability_zone_1
#   availability_zone_2 = var.availability_zone_2
#   env = var.env
#   region = var.region
# }

module "resources" {
    source = "./modules/resources"

  owner              = var.owner_name
  project            = var.project_name
  main_vpc_cidr      = var.main_vpc_cidr
  main_vpc_id = "vpc-0f9c1fae11c6cbd79"
#   main_vpc_id = module.vpc.vpc_id
  public_subnet_1 = var.public_subnet_1
  public_subnet_2 = var.public_subnet_2
  first_telegram_cidr = var.first_telegram_cidr
  second_telegram_cidr = var.second_telegram_cidr
  filters_instance_type = var.filters_instance_type
  ubuntu_ami = var.ubuntu_ami
  polybot_port = var.polybot_port
  public_subnet_1_id = "subnet-0ff6b74a9f01f4f2d"
  public_subnet_2_id = "subnet-005569cab5dbde989"
  instance_ids = ["i-0d6e0073a45decb07", "i-0c6d0775fe42bb3fa"]
#   public_subnet_1_id = module.vpc.public_subnet_id_1
#   public_subnet_2_id = module.vpc.public_subnet_id_2
#   instance_ids = module.cluster.nodes_instance_ids
  region = var.region
  env = var.env
  domain_name = var.domain_name
}

# module "permissions" {
#   source = "./modules/permissions"
#   owner              = var.owner_name
#   project            = var.project_name
#   bucket_arn = module.resources.bucket_arn
#   dynamodb_table_arn = module.resources.dynamodb_table_arn
#   yolov5_sqs_queue_arn = module.resources.yolov5_sqs_queue_arn
#   filters_sqs_queue_arn = module.resources.filters_sqs_queue_arn
#   main_vpc_cidr = var.main_vpc_cidr
#   region = var.region
#   env = var.env
# }
#
#
# module "cluster" {
#     source = "./modules/cluster"
#
#   control_plane_iam_role = module.permissions.control_plane_instance_profile
#   worker_node_iam_role = module.permissions.worker_nodes_instance_profile
#   public_subnet_ids      = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
#   vpc_id                 = module.vpc.vpc_id
#   region = var.region
#   number_of_worker_machines = var.number_of_worker_machines
#   public_key_name = var.public_key_name
#   ubuntu_ami = var.ubuntu_ami
#   cluster_name              = var.cluster_name
#   instance_type             = var.instance_type
#   owner_name                = var.owner_name
#   project_name              = var.project_name
#   env = var.env
# }
