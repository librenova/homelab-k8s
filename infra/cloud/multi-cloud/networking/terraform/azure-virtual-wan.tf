# Azure Virtual WAN for multi-cloud connectivity
resource "azurerm_virtual_wan" "multi_cloud_vwan" {
  name                = "multi-cloud-vwan"
  location            = "East US"
  resource_group_name = "multi-cloud-rg"
}
