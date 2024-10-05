resource "azurerm_linux_function_app" "fa" {
  name                = "fa-${random_id.environment.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  service_plan_id = azurerm_service_plan.sp.id

  storage_account_name          = azurerm_storage_account.function_app.name
  storage_uses_managed_identity = true

  virtual_network_subnet_id = azurerm_subnet.function_app.id

  public_network_access_enabled = false

  site_config {
    vnet_route_all_enabled = true

    application_stack {
      use_dotnet_isolated_runtime = true
      dotnet_version              = "8.0"
    }

    always_on = true

    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
  }

  app_settings = {
    https_only = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [
    azurerm_private_endpoint.sa_blob_pe,
    azurerm_private_endpoint.sa_table_pe,
    azurerm_private_endpoint.sa_queue_pe,
    azurerm_private_endpoint.sa_file_pe
  ]
}

resource "azurerm_private_endpoint" "fa_pe" {
  name                = format("pe-%s-sites", azurerm_linux_function_app.fa.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.azurewebsites.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-sites", azurerm_linux_function_app.fa.name)
    private_connection_resource_id = azurerm_linux_function_app.fa.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
