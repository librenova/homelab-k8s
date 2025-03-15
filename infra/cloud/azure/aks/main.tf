resource "azurerm_kubernetes_cluster" "aks" {
  name                = "azure-aks-cluster"
  location            = "East US"
  resource_group_name = "azure-rg"
  dns_prefix          = "azureaks"
}
