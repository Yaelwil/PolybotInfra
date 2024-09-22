resource "aws_s3_bucket" "project_bucket_prod" {
  bucket = "${var.owner}-bucket-prod-${var.region}-${var.project}"
  acl    = "private"

#   lifecycle {
#     prevent_destroy = true
#   }

  tags = {
    Name      = "${var.owner}-bucket-prod-${var.region}-${var.project}"
    Terraform = "true"
  }
}

resource "aws_s3_bucket_versioning" "example_prod" {
  bucket = aws_s3_bucket.project_bucket_prod.id

  versioning_configuration {
    status = "Enabled"
  }
}