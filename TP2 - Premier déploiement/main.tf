
# 1️⃣ Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "my-training-rg"
  location = "France Central"
}

# 2️⃣ Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "my-training-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# 3️⃣ Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "my-training-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4️⃣ Network Interface (sans public IP)
resource "azurerm_network_interface" "nic" {
  name                = "my-training-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 5️⃣ Ubuntu VM 18.04
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "my-training-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "Password1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "my-training-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "my-training-env"
  }
}
