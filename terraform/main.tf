resource "azurerm_resource_group" "vnet_rg" {
  name     = "${var.project_name}-vnet-${terraform.workspace}"
  location = var.location
}

resource "azurerm_resource_group" "kube_rg" {
  name     = "${var.project_name}-kube-${terraform.workspace}"
  location = var.location
}

module "hub_vnet" {
  source                                         = "./modules/network"
  address_space                                  = ["10.0.0.0/22"]
  resource_group_name                            = azurerm_resource_group.vnet_rg.name
  location                                       = var.location
  vnet_name                                      = "${var.project_name}-${var.hub_vnet_name}-${terraform.workspace}"
  enforce_private_link_endpoint_network_policies = false
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_space : ["10.0.1.0/24"]
      enable_service_endpoint_for_vault : false
    },
    {
      name : "JumpBoxSubnet"
      address_space : ["10.0.2.0/24"]
      enable_service_endpoint_for_vault : true
    }
  ]
}

module "spoke_vnet" {
  source                                         = "./modules/network"
  address_space                                  = ["30.0.0.0/21"]
  resource_group_name                            = azurerm_resource_group.kube_rg.name
  location                                       = var.location
  vnet_name                                      = "${var.project_name}-${var.spoke_vnet_name}-${terraform.workspace}"
  enforce_private_link_endpoint_network_policies = true
  subnets = [
    {
      name : "AKS-Subnet1"
      address_space : ["30.0.0.0/21"]
      enable_service_endpoint_for_vault : true
    }
  ]
}

module "vnet_peering" {
  source              = "./modules/vnet_peering"
  vnet1_id            = module.hub_vnet.vnet_id
  vnet1_name          = module.hub_vnet.vnet_name
  vnet1_rg            = azurerm_resource_group.vnet_rg.name
  vnet2_id            = module.spoke_vnet.vnet_id
  vnet2_name          = module.spoke_vnet.vnet_name
  vnet2_rg            = azurerm_resource_group.kube_rg.name
  peering_name_1_to_2 = "HubtoSpoke1"
  peering_name_2_to_1 = "Spoke1toHub"
}

module "firewall" {
  source         = "./modules/firewall"
  resource_group = azurerm_resource_group.vnet_rg.name
  location       = var.location
  pip_name       = "${var.project_name}-azureFirewalls-ip-${terraform.workspace}"
  fw_name        = "${var.project_name}-kubenetfw-${terraform.workspace}"
  subnet_id      = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
}

module "routetable" {
  source             = "./modules/routetable"
  resource_group     = azurerm_resource_group.kube_rg.name
  location           = var.location
  rt_name            = "kubenetfw_fw_rt"
  route_name         = "kubenetfw_fw_r"
  firewal_private_ip = module.firewall.fw_private_ip
  subnet_id          = module.spoke_vnet.subnet_ids["AKS-Subnet1"]
}

module "aks" {
  source                     = "./modules/aks"
  subnet_id                  = module.spoke_vnet.subnet_ids["AKS-Subnet1"]
  private_aks_name           = "private-aks-${terraform.workspace}"
  location                   = var.location
  aks_version                = var.aks_version
  resource_group             = azurerm_resource_group.kube_rg.name
  nodepool_nodes_count       = var.nodepool_nodes_count
  nodepool_vm_size           = var.nodepool_vm_size
  network_docker_bridge_cidr = var.network_docker_bridge_cidr
  network_dns_service_ip     = var.network_dns_service_ip
  network_service_cidr       = var.network_service_cidr
  scope                      = azurerm_resource_group.vnet_rg.id
  depends_on                 = [module.routetable]
}

module "jumpbox" {
  source                  = "./modules/jumpbox"
  location                = var.location
  resource_group          = azurerm_resource_group.vnet_rg.name
  pip_name                = "${var.project_name}-jumpbox-publicIP-${terraform.workspace}"
  vm_name                 = "${var.project_name}-jumpbox-${terraform.workspace}"
  vnet_id                 = module.hub_vnet.vnet_id
  subnet_id               = module.hub_vnet.subnet_ids["JumpBoxSubnet"]
  dns_zone_name           = join(".", slice(split(".", module.aks.aks_private_fqdn), 1, length(split(".", module.aks.aks_private_fqdn))))
  dns_zone_resource_group = module.aks.aks_node_resource_group
}

/*data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
module "akv" {
  source                     = "./modules/akv"
  key_vault_name             = "${var.project_name}-${terraform.workspace}"
  resource_group_name        = azurerm_resource_group.kube_rg.name
  location                   = var.location
  key_vault_sku_pricing_tier = "standard"
  enable_purge_protection    = false
  access_policies = [
    {
      azure_ad_service_principal_names = [module.spoke_vnet.managed_identity_name]
      key_permissions                  = ["get", "list"]
      secret_permissions               = ["get", "list"]
      certificate_permissions          = ["get", "import", "list"]
      storage_permissions              = ["backup", "get", "list", "recover"]
    },
    {
      azure_ad_service_principal_names = [module.hub_vnet.managed_identity_name]
      key_permissions                  = ["create", "get", "list", "delete", "encrypt", "decrypt"]
      secret_permissions               = ["set", "get", "list", "delete", "set", "restore"]
      certificate_permissions          = ["create", "get", "import", "list"]
      storage_permissions              = ["backup", "get", "list", "recover"]
    }
  ]
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"

    # One or more IP Addresses, or CIDR Blocks to access this Key Vault.
    ip_rules = ["${chomp(data.http.myip.body)}/32"]

    # One or more Subnet ID's to access this Key Vault.
    virtual_network_subnet_ids = [module.hub_vnet.subnet_ids["JumpBoxSubnet"], module.spoke_vnet.subnet_ids["AKS-Subnet1"]]
  }
  enable_private_endpoint = true
  existing_vnet_id        = module.spoke_vnet.vnet_id
  existing_subnet_id      = module.spoke_vnet.subnet_ids["AKS-Subnet1"]
}*/
