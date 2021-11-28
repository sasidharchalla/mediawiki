output "fw_private_ip" {
  description = "Private IP of the firewall"
  value       = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}