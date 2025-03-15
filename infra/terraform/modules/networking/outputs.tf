output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "azure_vnet_id" {
  value = azurerm_virtual_network.main.id
}
