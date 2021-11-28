output "tls_private_key" {
  value     = tls_private_key.keypair.private_key_pem
  sensitive = true
}

output "jumpbox_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

resource "local_file" "private_pem" {
  filename = "${path.module}/private_key.pem"
  content  = tls_private_key.keypair.private_key_pem
}
