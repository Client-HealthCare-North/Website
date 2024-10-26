terraform{
    backend "s3" {
        
        bucket = "s3-remote-hcnorth"
        encrypt = true
        key = ".tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}