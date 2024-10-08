module "vpc" {
  source = "./modules/vpc"

  owner              = var.owner_name
  project            = var.project_name
  main_vpc_cidr      = var.main_vpc_cidr
  public_subnet_1    = var.public_subnet_1
  public_subnet_2    = var.public_subnet_2
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
  region = var.region
}

module "resources" {
    source = "./modules/resources"

  owner              = var.owner_name
  project            = var.project_name
  main_vpc_cidr      = var.main_vpc_cidr
  main_vpc_id = module.vpc.vpc_id
  public_subnet_1 = var.public_subnet_1
  public_subnet_2 = var.public_subnet_2
  first_telegram_cidr = var.first_telegram_cidr
  second_telegram_cidr = var.second_telegram_cidr
  filters_instance_type = var.filters_instance_type
  ubuntu_ami = var.ubuntu_ami
  polybot_port = var.polybot_port
  public_subnet_1_id = module.vpc.public_subnet_id_1
  public_subnet_2_id = module.vpc.public_subnet_id_2
  instance_ids = module.cluster.nodes_instance_ids
  region = var.region
  domain_name_dev = var.domain_name_dev
  domain_name_prod = var.domain_name_prod
}

module "permissions" {
  source = "./modules/permissions"
  owner              = var.owner_name
  project            = var.project_name
  main_vpc_cidr = var.main_vpc_cidr
  region = var.region
  bucket_arn_dev = module.resources.bucket_arn_dev
  bucket_arn_prod = module.resources.bucket_arn_prod
  dynamodb_table_arn_dev = module.resources.dynamodb_table_arn_dev
  dynamodb_table_arn_prod = module.resources.dynamodb_table_arn_prod
  filters_sqs_queue_arn_dev = module.resources.filters_sqs_queue_arn_dev
  filters_sqs_queue_arn_prod = module.resources.filters_sqs_queue_arn_prod
  yolov5_sqs_queue_arn_dev = module.resources.yolov5_sqs_queue_arn_dev
  yolov5_sqs_queue_arn_prod = module.resources.yolov5_sqs_queue_arn_prod
}


module "cluster" {
    source = "./modules/cluster"

  control_plane_iam_role = module.permissions.control_plane_instance_profile
  worker_node_iam_role = module.permissions.worker_nodes_instance_profile
  public_subnet_ids      = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
  vpc_id                 = module.vpc.vpc_id
  region = var.region
  number_of_worker_machines = var.number_of_worker_machines
  public_key_name = var.public_key_name
  ubuntu_ami = var.ubuntu_ami
  cluster_name              = var.cluster_name
  instance_type             = var.instance_type
  owner_name                = var.owner_name
  project_name              = var.project_name
}
