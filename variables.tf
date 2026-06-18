# Azure region where the lab will be deployed.
variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

# Resource group name for the lab.
variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
  default     = "rg-terraform-learning-lab"
}

# Prefix used to make resource names consistent and easy to identify.
variable "name_prefix" {
  description = "Prefix for Azure resource names."
  type        = string
  default     = "tflearn"
}

# Private IP range for the Virtual Network.
variable "vnet_address_space" {
  description = "Address space for the Virtual Network."
  type        = string
  default     = "10.10.0.0/16"
}

# Private IP range for the subnet inside the Virtual Network.
variable "subnet_address_prefix" {
  description = "Address prefix for the subnet."
  type        = string
  default     = "10.10.1.0/24"
}

# Limit SSH access to your public IP address in CIDR notation.
# Example: "203.0.113.10/32"
variable "allowed_ssh_cidr" {
  description = "Public IP CIDR allowed to SSH to the VM. Use your-ip/32."
  type        = string
}

# Admin username for the Ubuntu VM.
variable "admin_username" {
  description = "Admin username for SSH access."
  type        = string
  default     = "azureuser"
}

# Path to the public SSH key Terraform will place on the VM.
variable "ssh_public_key_path" {
  description = "Path to your SSH public key."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

# Small burstable VM size for cost control.
# If unavailable in your selected region, try Standard_B1s.
variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B1ls"
}

# VM size for the Nessus scanner.
# This defaults to the same size that worked in this subscription and region.
variable "scanner_vm_size" {
  description = "Azure VM size for the Nessus scanner VM."
  type        = string
  default     = "Standard_D2ls_v7"
}

# Small OS disk for cost control.
variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 30
}
