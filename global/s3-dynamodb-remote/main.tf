# Setting remote S3 as backend 
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

terraform {
  backend "s3" {
    profile        = "temp-profile"
    bucket         = "s3-remote-hcnorth"
    region         = "us-east-1"
    key            = "tfstate"
    dynamodb_table = "terraform_locks"
  }
}
/*
resource "aws_instance" "web" {
   ami = "ami-0ebfd941bbafe70c6"
   instance_type = "t2.micro"

   subnet_id = "subnet-0d3252efe8d652ce6"
   vpc_security_group_ids = ["sg-0b3bf2facd2141fc0"]

 tags = {
"Terraform" = "true" }
 }
 */
