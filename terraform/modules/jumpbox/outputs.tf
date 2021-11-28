output "tls_private_key" {
  value     = tls_private_key.keypair.private_key_pem
  sensitive = true
}

output "jumpbox_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

resource "local_file" "cloud_pem" {
  filename = "${path.module}/cloudtls.pem"
  content  = tls_private_key.keypair.private_key_pem
}