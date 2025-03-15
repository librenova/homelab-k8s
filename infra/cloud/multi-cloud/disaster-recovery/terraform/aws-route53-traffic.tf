# AWS Route 53 failover to Azure
resource "aws_route53_health_check" "azure_backup" {
  fqdn              = "azure-backup-service.example.com"
  port              = 443
  type              = "HTTPS"
  failure_threshold = 3
  request_interval  = 30
}
