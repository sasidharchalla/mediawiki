
/*output "private_dns_aks" {
  value = join(".",slice(split(".", module.aks.aks_private_fqdn),1,length(split(".", module.aks.aks_private_fqdn))))

}*/

output "tls_private_key_jumpbox" {
  value     = module.jumpbox.tls_private_key
  sensitive = true
}

output "jumpbox_public_ip" {
  value = module.jumpbox.jumpbox_public_ip
}
