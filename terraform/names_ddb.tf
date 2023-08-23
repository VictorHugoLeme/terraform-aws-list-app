resource "aws_dynamodb_table" "names_data" {
  name             = "NamesData"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-test-table"
    Environment = "dev"
  }
}