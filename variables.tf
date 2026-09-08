variable "location" {
  description = "Azure region for the lab resources"
  type        = string
  default     = "uaenorth"
}

variable "resource_group_name" {
  description = "Name of the lab resource group"
  type        = string
  default     = "RG-Terraform-Enterprise-Lab"
}

variable "vm_size" {
  description = "Size of the application VM"
  type        = string
  default     = "Standard_F1als_v7"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM"
  type        = string
  default     = "azureadmin"
}