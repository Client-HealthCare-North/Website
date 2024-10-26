resource "aws_s3_bucket" "artifacts" {
  bucket = "hcn-artifacts-pod4"
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.owner,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}