resource "aws_dynamodb_table" "dynamodb-table_dev" {
  name           = "${var.owner}-dynamodb-table-dev-${var.region}-${var.project}"
  billing_mode   = "PAY_PER_REQUEST"  # Adjust based on your requirements

  attribute {
    name = "prediction_id"
    type = "S"  # S for string, adjust as needed for other types
  }

  # Define the primary key
  hash_key = "prediction_id"  # Partition key

  tags = {
    Name = "${var.owner}-dynamodb-dev-${var.region}-${var.project}"
    Terraform = "true"
  }
}
