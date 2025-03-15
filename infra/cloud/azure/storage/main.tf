resource "azurerm_storage_account" "storage" {
  name                     = "azurestoragetf"
  resource_group_name      = "azure-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
