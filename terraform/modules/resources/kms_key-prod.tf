resource "aws_kms_key" "kms_key_prod" {
  description             = "${var.owner}-kms-key-prod-${var.region}-${var.project}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name = "${var.owner}-kms-key-prod-${var.region}-${var.project}"
    Terraform = "true"
  }
}

resource "aws_kms_alias" "kms_alias_prod" {
  name          = "alias/${var.owner}-kms-key-prod-${var.region}-${var.project}"
  target_key_id = aws_kms_key.kms_key_prod.key_id
}