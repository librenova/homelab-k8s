# AWS S3 replication to Azure Blob Storage
resource "aws_s3_bucket" "multi_cloud_bucket" {
  bucket = "multi-cloud-backup"
  acl    = "private"
}
