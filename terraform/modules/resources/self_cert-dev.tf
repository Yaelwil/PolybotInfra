provider "tls" {
  version = "~> 3.1"
}

resource "tls_private_key" "example_dev" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "example_dev" {
  private_key_pem = tls_private_key.example_dev.private_key_pem

  subject {
    common_name  = var.domain_name_dev
    organization = "Example Organization"
  }

  validity_period_hours = 8760  # 1 year
  early_renewal_hours   = 720   # 30 days before expiration

  dns_names = [
    var.domain_name_dev
  ]

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

###################
# ACM Certificate #
###################

resource "aws_acm_certificate" "dev" {
  private_key       = tls_private_key.example_dev.private_key_pem
  certificate_body  = tls_self_signed_cert.example_dev.cert_pem
  tags = {
    Name = "${var.owner}-self-sign-certificate-dev-${var.region}-${var.project}"
  }
}