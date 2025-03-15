resource "aws_iam_role" "azure_ad_federation" {
  name = "AzureADFederationRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:saml-provider/AzureAD" },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": { "StringEquals": { "SAML:aud": "https://signin.aws.amazon.com/saml" } }
    }
  ]
}
POLICY
}
