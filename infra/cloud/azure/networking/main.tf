resource "azurerm_virtual_network" "vnet" {
  name                = "azure-vnet"
  location            = "East US"
  resource_group_name = "azure-rg"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "azure-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = "azure-rg"
  address_prefixes     = ["10.1.1.0/24"]
}
