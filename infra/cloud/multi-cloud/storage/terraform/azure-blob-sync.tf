# Azure Blob Storage for cross-cloud backup
resource "azurerm_storage_account" "multi_cloud_storage" {
  name                     = "multicloudstorage"
  resource_group_name      = "multi-cloud-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
