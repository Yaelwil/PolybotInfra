resource "aws_s3_bucket" "project_bucket_dev" {
  bucket = "${var.owner}-bucket-dev-${var.region}-${var.project}"
  acl    = "private"

#   lifecycle {
#     prevent_destroy = true
#   }

  tags = {
    Name      = "${var.owner}-bucket-dev-${var.region}-${var.project}"
    Terraform = "true"
  }
}

resource "aws_s3_bucket_versioning" "example_dev" {
  bucket = aws_s3_bucket.project_bucket_dev.id

  versioning_configuration {
    status = "Enabled"
  }
}