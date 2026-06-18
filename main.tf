# This block tells Terraform which provider plugins this project needs.
# The azurerm provider is the official Terraform provider for Azure Resource Manager.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# This block configures the Azure provider.
# Authentication is handled by Azure CLI after you run `az login`.
provider "azurerm" {
  # Beginner lab accounts often do not have permission to register Azure
  # resource providers. This keeps Terraform from trying to manage provider
  # registration automatically.
  resource_provider_registrations = "none"

  features {}
}

# Locals are named values that make the Terraform code easier to read.
# These tags are applied to every Azure resource that supports tags.
locals {
  common_tags = {
    Environment = "Lab"
    Owner       = "James"
    Project     = "Terraform-Learning"
  }
}

# A Resource Group is a logical container for all lab resources.
# Deleting the Resource Group deletes everything inside it.
resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}

# A Virtual Network gives the lab a private network address space.
# The VM's private IP address will live inside this network.
resource "azurerm_virtual_network" "lab" {
  name                = "${var.name_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  tags = local.common_tags
}

# A Subnet divides the Virtual Network into a smaller address range.
# The VM's network interface is placed into this subnet.
resource "azurerm_subnet" "lab" {
  name                 = "${var.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [var.subnet_address_prefix]
}

# A Network Security Group acts like a basic cloud firewall.
# This target NSG allows inbound SSH only from the CIDR block you provide.
resource "azurerm_network_security_group" "lab" {
  name                = "${var.name_prefix}-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "Allow-SSH-From-My-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# This scanner NSG protects the Nessus scanner VM.
# SSH and the Nessus web UI are limited to your public IP address.
resource "azurerm_network_security_group" "scanner" {
  name                = "${var.name_prefix}-scanner-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "Allow-SSH-From-My-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Nessus-UI-From-My-IP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8834"
    source_address_prefix      = var.allowed_ssh_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# A Public IP address lets you reach the VM from your Mac over SSH.
# Standard Public IPs use Static allocation in Azure.
resource "azurerm_public_ip" "lab" {
  name                = "${var.name_prefix}-public-ip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

# A separate Public IP lets you reach the Nessus scanner VM without exposing
# the target VM's management surface more than necessary.
resource "azurerm_public_ip" "scanner" {
  name                = "${var.name_prefix}-scanner-public-ip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

# A Network Interface connects the VM to the subnet.
# It also attaches the Public IP so SSH can reach the VM.
resource "azurerm_network_interface" "lab" {
  name                = "${var.name_prefix}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab.id
  }

  tags = local.common_tags
}

# This Network Interface connects the scanner VM to the same lab subnet.
# Nessus can scan the target VM over the private Azure network.
resource "azurerm_network_interface" "scanner" {
  name                = "${var.name_prefix}-scanner-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.scanner.id
  }

  tags = local.common_tags
}

# This association attaches the Network Security Group to the VM's NIC.
# Without this, the NSG rules would not protect this VM interface.
resource "azurerm_network_interface_security_group_association" "lab" {
  network_interface_id      = azurerm_network_interface.lab.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

# Attach the scanner NSG to the scanner NIC.
resource "azurerm_network_interface_security_group_association" "scanner" {
  network_interface_id      = azurerm_network_interface.scanner.id
  network_security_group_id = azurerm_network_security_group.scanner.id
}

# The Linux VM is the actual compute resource for the lab.
# Standard_B1ls is usually one of Azure's smallest low-cost VM sizes, but it may
# not be available in every region or subscription. You can override it in tfvars.
resource "azurerm_linux_virtual_machine" "lab" {
  name                = "${var.name_prefix}-ubuntu-vm"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.lab.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    name                 = "${var.name_prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = local.common_tags
}

# The scanner VM is where Nessus Essentials will run.
# It is separate from the target VM so scanning resembles a real environment.
resource "azurerm_linux_virtual_machine" "scanner" {
  name                = "${var.name_prefix}-nessus-scanner-vm"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.scanner_vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.scanner.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    name                 = "${var.name_prefix}-scanner-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = merge(local.common_tags, {
    Role = "Scanner"
  })
}
