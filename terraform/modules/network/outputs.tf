output "vnet_id" {
  description = "Generated VNET ID"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "VNET Name"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "Generated subnet IDs"
  value       = { for subnet in azurerm_subnet.vnet_subnet : subnet.name => subnet.id }
}

output "managed_identity" {
  description = "Service principal of managed identity"
  value       = azurerm_user_assigned_identity.vnet_managed_identity.principal_id
}

output "managed_identity_name" {
  description = "Name of the managed identity"
  value       = azurerm_user_assigned_identity.vnet_managed_identity.name
}

