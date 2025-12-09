output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "storage_account_name" {
  description = "Name of the storage account for flow logs"
  value       = azurerm_storage_account.flowlogs.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.flowlogs.id
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "flow_logs_enabled" {
  description = "VNet flow logs status"
  value       = azurerm_network_watcher_flow_log.main.enabled
}

output "flow_logs_retention_days" {
  description = "VNet flow logs retention period in days"
  value       = azurerm_network_watcher_flow_log.main.retention_policy[0].days
}
