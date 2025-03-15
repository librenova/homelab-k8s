resource "aws_route53_health_check" "azure_backup" {
  fqdn              = "azure-backup-service.example.com"
  port              = 443
  type              = "HTTPS"
  failure_threshold = 3
  request_interval  = 30
}

resource "azurerm_traffic_manager_profile" "aws_failover" {
  name                = "aws-failover"
  resource_group_name = "azure-rg"
  traffic_routing_method = "Priority"
}
