data "azurerm_kubernetes_service_versions" "desired_version" {
  location       = var.location
  version_prefix = var.aks_version
}

data "azurerm_kubernetes_service_versions" "latest" {
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aksprivate" {
  name                    = var.private_aks_name
  location                = var.location
  kubernetes_version      = data.azurerm_kubernetes_service_versions.desired_version.versions != "" ? data.azurerm_kubernetes_service_versions.desired_version.versions[0] : data.azurerm_kubernetes_service_versions.latest.latest_version
  resource_group_name     = var.resource_group
  dns_prefix              = var.private_aks_name
  private_cluster_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = var.nodepool_nodes_count
    vm_size        = var.nodepool_vm_size
    vnet_subnet_id = var.subnet_id

  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = "azure"
    outbound_type      = "userDefinedRouting"
    service_cidr       = var.network_service_cidr
  }
}

# Assigning role to create azure resources for the principal Id that was created by aks cluster.
#https://github.com/Azure/AKS/issues/1557
resource "azurerm_role_assignment" "vmcontributor" {
  role_definition_name = "Virtual Machine Contributor"
  scope                = var.scope
  principal_id         = azurerm_kubernetes_cluster.aksprivate.identity[0].principal_id
}

resource "azurerm_role_assignment" "managedIdentityOperator" {
  role_definition_name = "Managed Identity Operator"
  scope                = var.scope
  principal_id         = azurerm_kubernetes_cluster.aksprivate.identity[0].principal_id
}
