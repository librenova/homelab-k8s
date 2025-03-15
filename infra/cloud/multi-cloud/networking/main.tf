resource "aws_vpc_peering_connection" "multi_cloud" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = azurerm_virtual_network.vnet.id
  auto_accept = true
}
