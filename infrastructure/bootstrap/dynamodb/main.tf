resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.env["terraform"]["state_locks"]}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
