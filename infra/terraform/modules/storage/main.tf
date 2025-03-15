resource "aws_s3_bucket" "main" {
  bucket = "my-terraform-bucket"
  acl    = "private"
}
