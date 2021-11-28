variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location where route table will be deployed"
  type        = string
}

variable "rt_name" {
  description = "Name of the route table"
  type        = string
  default     = "Route-table"
}

variable "route_name" {
  description = "Name of the route"
  type        = string
  default     = "Route-table"
}

variable "firewal_private_ip" {
  description = "Firewall private IP"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for route table association"
  type        = string
}