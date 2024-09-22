###########
# Secrets #
###########
# Store the certificate body in Secrets Manager
resource "aws_secretsmanager_secret" "certificate_dev" {
  name = "${var.owner}-certificate-dev-${var.region}-${uuid()}-${var.project}"
  kms_key_id = aws_kms_key.kms_key_dev.id  # Reference to the KMS key

   lifecycle {
#      prevent_destroy = true
     ignore_changes = [name]
   }
}

resource "aws_secretsmanager_secret_version" "certificate_version_dev" {
  secret_id     = aws_secretsmanager_secret.certificate_dev.id
  secret_string = tls_self_signed_cert.example_dev.cert_pem
}

# Store the Private key in Secrets Manager
resource "aws_secretsmanager_secret" "private_key_dev" {
  name = "${var.owner}-certificate-pk-dev-${var.region}-${uuid()}-${var.project}"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_secretsmanager_secret_version" "private_key_dev" {
  secret_id     = aws_secretsmanager_secret.private_key_dev.id
  secret_string = tls_private_key.example_dev.private_key_pem
}