resource "azurerm_public_ip" "application" {
  name                = "PIP-AppVM"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = azurerm_resource_group.lab.tags
}

resource "azurerm_network_interface" "application" {
  name                = "NIC-AppVM"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "ipconfig-application"
    subnet_id                     = azurerm_subnet.application.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.application.id
  }

  tags = azurerm_resource_group.lab.tags
}

resource "azurerm_linux_virtual_machine" "application" {
  name                = "VM-App-Linux"
  computer_name       = "appvm01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.vm_size
  admin_username      = var.admin_username
  identity {
    type = "SystemAssigned"
  }

  network_interface_ids = [
    azurerm_network_interface.application.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand("~/.ssh/terraform-lab.pub"))
  }

  os_disk {
    name                 = "Disk-AppVM-OS"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-CLOUD_INIT
    #cloud-config
    package_update: true
    packages:
      - nginx

    write_files:
      - path: /var/www/html/index.html
        permissions: "0644"
        content: |
          <h1>Terraform Azure Enterprise Lab</h1>
          <p>Deployed by Mohd Javed using Terraform.</p>

    runcmd:
      - systemctl enable nginx
      - systemctl restart nginx
  CLOUD_INIT
  )

  tags = azurerm_resource_group.lab.tags
}
