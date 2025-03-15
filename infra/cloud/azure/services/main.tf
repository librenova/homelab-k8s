resource "azurerm_mssql_server" "database" {
  name                         = "azure-sql-server"
  resource_group_name          = "azure-rg"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = "securepassword"
}
