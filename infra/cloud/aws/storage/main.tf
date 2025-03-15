resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  acl    = "private"
}

resource "aws_ebs_volume" "storage" {
  availability_zone = "us-east-1a"
  size             = 100
}
