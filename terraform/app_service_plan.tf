resource "azurerm_service_plan" "sp" {
  name                = "asp-${random_id.environment.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = "P1v3"
}
