resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "vnet_subnet" {
  for_each             = { for subnet in var.subnets : subnet.name => [subnet.address_space, subnet.enable_service_endpoint_for_vault] }
  name                 = each.key
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value[0]
  resource_group_name  = var.resource_group_name
  //AKS will disable this if a private cluster is enabled
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies ? true : false
  service_endpoints                              = each.value[1] ? ["Microsoft.KeyVault"] : []
}

resource "azurerm_user_assigned_identity" "vnet_managed_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name = "${var.vnet_name}-${terraform.workspace}-managed_identity"
}