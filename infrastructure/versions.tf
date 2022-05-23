terraform {
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-bucket-watchwolf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-dynamodb-locks"
  }
}
