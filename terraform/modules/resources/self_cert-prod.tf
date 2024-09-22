resource "tls_private_key" "example_prod" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "example_prod" {
  private_key_pem = tls_private_key.example_prod.private_key_pem

  subject {
    common_name  = var.domain_name_prod
    organization = "Example Organization"
  }

  validity_period_hours = 8760  # 1 year
  early_renewal_hours   = 720   # 30 days before expiration

  dns_names = [
    var.domain_name_prod
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

resource "aws_acm_certificate" "prod" {
  private_key       = tls_private_key.example_prod.private_key_pem
  certificate_body  = tls_self_signed_cert.example_prod.cert_pem
  tags = {
    Name = "${var.owner}-self-sign-certificate-prod-${var.region}-${var.project}"
  }
}