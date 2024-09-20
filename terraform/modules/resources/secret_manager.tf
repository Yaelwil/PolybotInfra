###########
# Secrets #
###########
# Store the certificate body in Secrets Manager
resource "aws_secretsmanager_secret" "certificate" {
  name = "${var.owner}-certificate-${var.env}-${var.region}-${uuid()}-${var.project}"
  kms_key_id = aws_kms_key.kms_key.id  # Reference to the KMS key

   lifecycle {
#      prevent_destroy = true
     ignore_changes = [name]
   }
}

resource "aws_secretsmanager_secret_version" "certificate_version" {
  secret_id     = aws_secretsmanager_secret.certificate.id
  secret_string = tls_self_signed_cert.example.cert_pem
}

# Store the Private key in Secrets Manager
resource "aws_secretsmanager_secret" "private_key" {
  name = "${var.owner}-certificate-pk-${var.env}-${var.region}-${uuid()}-${var.project}"

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_secretsmanager_secret_version" "private_key" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = tls_private_key.example.private_key_pem
}