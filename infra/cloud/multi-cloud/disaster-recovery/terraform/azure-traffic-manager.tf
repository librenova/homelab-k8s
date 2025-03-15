# Azure Traffic Manager failover to AWS
resource "azurerm_traffic_manager_profile" "aws_failover" {
  name                = "aws-failover"
  resource_group_name = "multi-cloud-rg"
  traffic_routing_method = "Priority"
}
