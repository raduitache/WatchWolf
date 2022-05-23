resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.bucket.arn
  }

  tags = merge(var.tags,
    {
      ApplicationRole = "${local.app_role}"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_kms_key" "s3_encryption_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}-bucket"
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
