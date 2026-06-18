# Shows the Resource Group name after deployment.
output "resource_group_name" {
  description = "Name of the created Resource Group."
  value       = azurerm_resource_group.lab.name
}

# Shows the VM name after deployment.
output "vm_name" {
  description = "Name of the Ubuntu VM."
  value       = azurerm_linux_virtual_machine.lab.name
}

# Shows the public IP address after Azure assigns it.
output "public_ip_address" {
  description = "Public IP address for SSH."
  value       = azurerm_public_ip.lab.ip_address
}

# Gives you the exact SSH command to connect to the VM.
output "ssh_command" {
  description = "SSH command for connecting to the VM."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.lab.ip_address}"
}

# Shows the scanner VM name.
output "scanner_vm_name" {
  description = "Name of the Nessus scanner VM."
  value       = azurerm_linux_virtual_machine.scanner.name
}

# Shows the scanner VM public IP address.
output "scanner_public_ip_address" {
  description = "Public IP address for the Nessus scanner VM."
  value       = azurerm_public_ip.scanner.ip_address
}

# Gives you the exact SSH command for the scanner VM.
output "scanner_ssh_command" {
  description = "SSH command for connecting to the Nessus scanner VM."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.scanner.ip_address}"
}

# Gives you the Nessus web UI URL after Nessus is installed and running.
output "nessus_url" {
  description = "Nessus web UI URL on the scanner VM."
  value       = "https://${azurerm_public_ip.scanner.ip_address}:8834"
}

# Private target IP to scan from the Nessus scanner VM.
output "target_private_ip_address" {
  description = "Private IP address of the target VM for internal scanning."
  value       = azurerm_network_interface.lab.private_ip_address
}
