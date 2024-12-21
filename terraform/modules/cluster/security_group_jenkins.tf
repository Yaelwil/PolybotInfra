#################################################
# Security group for Control Plane EC2 instances #
#################################################
resource "aws_security_group" "jenkins_sg" {
  name = "${var.owner_name}-jenkins-sg-${var.region}-${var.project_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound rules (allowing all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.owner_name}-jenkins-sg-${var.region}-${var.project_name}"
    Terraform = "true"
  }
}
