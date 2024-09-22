###########
# Secrets #
###########
# Store the certificate body in Secrets Manager
resource "aws_secretsmanager_secret" "certificate_prod" {
  name = "${var.owner}-certificate-prod-${var.region}-${uuid()}-${var.project}"
  kms_key_id = aws_kms_key.kms_key_prod.id  # Reference to the KMS key

   lifecycle {
#      prevent_destroy = true
     ignore_changes = [name]
   }
}

resource "aws_secretsmanager_secret_version" "certificate_version_prod" {
  secret_id     = aws_secretsmanager_secret.certificate_prod.id
  secret_string = tls_self_signed_cert.example_prod.cert_pem
}

# Store the Private key in Secrets Manager
resource "aws_secretsmanager_secret" "private_key_prod" {
  name = "${var.owner}-certificate-pk-prod-${var.region}-${uuid()}-${var.project}"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_secretsmanager_secret_version" "private_key_prod" {
  secret_id     = aws_secretsmanager_secret.private_key_prod.id
  secret_string = tls_private_key.example_prod.private_key_pem
}