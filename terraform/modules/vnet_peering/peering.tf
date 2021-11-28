resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = var.peering_name_1_to_2
  resource_group_name       = var.vnet1_rg
  virtual_network_name      = var.vnet1_name
  remote_virtual_network_id = var.vnet2_id
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = var.peering_name_2_to_1
  resource_group_name       = var.vnet2_rg
  virtual_network_name      = var.vnet2_name
  remote_virtual_network_id = var.vnet1_id
}