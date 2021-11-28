variable "vnet1_name" {
  description = "Name of the VNET 1"
  type        = string
}

variable "vnet2_name" {
  description = "Name of the VNET 2"
  type        = string
}

variable "vnet1_rg" {
  # Resource Group where this Link gets created
  description = "Resource Group of the VNET 1"
  type        = string
}

variable "vnet2_rg" {
  # Resource Group where this Link gets created
  description = "Resource Group of the VNET 2"
  type        = string
}

variable "vnet1_id" {
  description = "VNET 1 ID"
  type        = string
}

variable "vnet2_id" {
  description = "VNET 2 ID"
  type        = string
}

variable "peering_name_1_to_2" {
  description = "Peering 1 to 2 name"
  type        = string
  default     = "peering1to2"
}

variable "peering_name_2_to_1" {
  description = "Peering 2 to 1 name"
  type        = string
  default     = "peering2to1"
}