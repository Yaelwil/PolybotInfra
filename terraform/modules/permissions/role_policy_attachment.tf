#################
# Control Plane #
#################

resource "aws_iam_role_policy_attachment" "control_plane_role_to_s3_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_role_to_dynamodb_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_role_to_sqs_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_role_to_sm_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.secrets_manager_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_role_to_kms_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_role_to_route53_policy_attachment" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.route53_policy.arn
}

resource "aws_iam_role_policy_attachment" "control_plane_to_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role     = aws_iam_role.control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "control_plane_to_ebs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role     = aws_iam_role.control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "control_plane_to_ecr_read_only_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role     = aws_iam_role.control_plane_role.name
}

resource "aws_iam_instance_profile" "control_plane_instance_profile" {
  name = "${var.owner}-control-plane-instance-profile-${var.env}-${var.project}"

  role = aws_iam_role.control_plane_role.name  // Reference to the IAM role name

  tags = {
    Name      = "${var.owner}-control-plane-instance-profile-${var.env}-${var.project}"
    Terraform = "true"
  }
}

################
# Worker Nodes #
################

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_s3_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_dynamodb_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_sqs_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}


resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_sm_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.secrets_manager_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_kms_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}


resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_route53_policy_attachment" {
  role       = aws_iam_role.worker_nodes_role.name
  policy_arn = aws_iam_policy.route53_policy.arn
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role     = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_ecr_read_only_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role     = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "worker_nodes_role_to_ebs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role     = aws_iam_role.worker_nodes_role.name
}

resource "aws_iam_instance_profile" "worker_node_instance_profile" {
  name = "${var.owner}-worker-nodes-instance-profile-${var.env}-${var.project}"

  role = aws_iam_role.worker_nodes_role.name  // Reference to the IAM role name

  tags = {
    Name      = "${var.owner}-worker-nodes-instance-profile-${var.env}-${var.project}"
    Terraform = "true"
  }
}

########
# Pods #
########

resource "aws_iam_role_policy_attachment" "pods_role_to_s3_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "pods_role_to_dynamodb_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "pods_role_to_sqs_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}


resource "aws_iam_role_policy_attachment" "pods_role_to_sm_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.secrets_manager_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "pods_role_to_kms_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}


resource "aws_iam_role_policy_attachment" "pods_role_to_route53_policy_attachment" {
  role       = aws_iam_role.pod_role.name
  policy_arn = aws_iam_policy.route53_policy.arn
}