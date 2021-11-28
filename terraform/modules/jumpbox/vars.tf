variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location where Firewall will be deployed"
  type        = string
}

variable "pip_name" {
  description = "Public IP of the VM"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vnet_id" {
  description = "ID of the VNET where VM will be installed"
  type        = string
}

variable "subnet_id" {
  description = "ID of subnet where VM will be installed"
  type        = string
}

variable "dns_zone_name" {
  description = "Private DNS Zone name to link VM's vnet to"
  type        = string
}

variable "dns_zone_resource_group" {
  description = "Private DNS Zone resource group"
  type        = string
}


