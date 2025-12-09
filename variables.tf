variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-flowlogs-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "storage_account_name" {
  description = "Name of the storage account for flow logs (must be globally unique, 3-24 chars, lowercase letters and numbers only)"
  type        = string
  default     = "stflowlogs"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-main"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-demo"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  # You should provide your own SSH public key
  # Generate one with: ssh-keygen -t rsa -b 4096
}
