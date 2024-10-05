resource "azurerm_resource_group" "rg" {
  name     = "rg-${random_id.environment.hex}"
  location = var.location
}
