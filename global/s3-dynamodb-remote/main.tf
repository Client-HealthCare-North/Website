# Including providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Setting remote S3 as backend 
terraform {
  backend "s3" {
    profile        = "temp-profile"
    bucket         = "s3-remote-hcnorth"
    region         = "us-east-1"
    key            = "tfstate"
    dynamodb_table = "terraform_locks"
  }
}

