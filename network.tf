resource "azurerm_virtual_network" "main" {
  name                = "VNet-Enterprise-Lab"
  address_space       = ["10.50.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  tags = azurerm_resource_group.lab.tags
}
resource "azurerm_subnet" "management" {
  name                 = "SNet-Management"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.50.1.0/24"]
}

resource "azurerm_subnet" "application" {
  name                 = "SNet-Application"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.50.2.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "SNet-Database"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.50.3.0/24"]
}