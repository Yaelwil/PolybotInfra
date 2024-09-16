region             = "us-east-2"
availability_zone_1 = "us-east-2a"
availability_zone_2 = "us-east-2b"
env = "prod"
instance_type= "t3.medium"
owner_name = "yaelwil"
project_name = "k8s-project"
cluster_name = "yaelwil-cluster-k8s"
number_of_worker_machines = 1
ubuntu_ami = "ami-085f9c64a9b75eed5"
polybot_port= 8443
main_vpc_cidr      = "10.0.0.0/16"
public_subnet_1    = "10.0.1.0/24"
public_subnet_2    = "10.0.2.0/24"
first_telegram_cidr = "149.154.160.0/20"
second_telegram_cidr = "91.108.4.0/22"
public_key_name    = "yaelwil-ohio"
yolov5_instance_type = "t2.medium"
filters_instance_type = "t2.micro"
yolov5_ebs_dev_name = "/dev/sdh"
yolov5_ebs_volume_size = 30
yolov5_ebs_volume_type = "gp2"
asg_filters_desired_capacity = 1
asg_filters_max_size = 5
asg_filters_min_size = 1
asg_yolov5_desired_capacity = 1
asg_yolov5_max_size = 5
asg_yolov5_min_size = 1
filters_ebs_dev_name = "/dev/sdh"
filters_ebs_volume_size = 20
filters_ebs_volume_type = "gp2"