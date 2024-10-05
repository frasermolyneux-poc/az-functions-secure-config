resource "azurerm_virtual_network" "poc" {
  name          = "vnet-function-app"
  address_space = ["10.0.0.0/16"]

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "function_app" {
  name                 = "subnet-function-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.poc.name

  address_prefixes = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "endpoints" {
  name                 = "subnet-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.poc.name

  address_prefixes = ["10.0.2.0/24"]
}
