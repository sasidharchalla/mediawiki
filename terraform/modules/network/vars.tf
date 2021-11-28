variable "address_space" {
  description = "Address space for VNET"
  type        = list(string)
}


variable "location" {
  description = "Location for the VNET"
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNET"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}
variable "enforce_private_link_endpoint_network_policies" {
  description = "Enable or Disable network policies for the private link endpoint on the subnet"
  type        = bool
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name                              = string
    address_space                     = list(string)
    enable_service_endpoint_for_vault = bool
    }
  ))
}