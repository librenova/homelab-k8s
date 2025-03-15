# RBAC for managing multi-cloud users
resource "aws_iam_policy" "multi_cloud_policy" {
  name   = "MultiCloudAccessPolicy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY
}
