resource "aws_instance" "control_plane" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  key_name               = var.public_key_name
  iam_instance_profile   = var.control_plane_iam_role
  security_groups        = [aws_security_group.control_plane_sg.id]

  tags = {
    Name = "${var.owner_name}-control-plane-${var.region}-${var.project_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  root_block_device {
    volume_size = 20
  }

  user_data = templatefile("./modules/cluster/node-bootstrap.sh", {
    aws_region = var.region
    k8s_version = var.k8s_version
  })
}


resource "aws_instance" "worker_node" {
  # number of worker nodes to provision
  count = var.number_of_worker_machines

  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  key_name               = var.public_key_name
  iam_instance_profile   = var.worker_node_iam_role
  security_groups        = [aws_security_group.worker_node_sg.id]

  tags = {
    Name = "${var.owner_name}-worker-node-${var.region}-${var.project_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  root_block_device {
    volume_size = 20
  }

  user_data = templatefile("./modules/cluster/node-bootstrap.sh", {
    aws_region = var.region
    k8s_version = var.k8s_version
  })
}

resource "aws_instance" "jenkins" {

  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[1]
  key_name               = var.public_key_name
  security_groups        = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "${var.owner_name}-jenkins-${var.region}-${var.project_name}"
    Terraform = "true"
  }

  root_block_device {
    volume_size = 20
  }

  user_data = templatefile("./modules/cluster/install_docker.sh", {
  })
}