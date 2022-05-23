resource "aws_s3_bucket" "terraform_state" {
  bucket = local.env["terraform"]["state_bucket"]

  tags = merge(
    local.env["tags"],
    {
      ApplicationRole = "state"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
