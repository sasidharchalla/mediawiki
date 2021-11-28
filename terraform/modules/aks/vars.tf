variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 1
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_B2s"
}

variable "network_docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.17.0.1/16"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.2.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "10.2.0.0/24"
}

variable "subnet_id" {
  description = "Name of the Subnet to deploy AKS cluster"
}

variable "private_aks_name" {
  description = "Name of the  AKS cluster"
}

variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location where Firewall will be deployed"
  type        = string
}

variable "scope" {
  description = "Scope of the role that's assigned to AKS cluster"
  type        = string
}

variable "aks_version" {
  description = "AKS Version"
  type        = string
}