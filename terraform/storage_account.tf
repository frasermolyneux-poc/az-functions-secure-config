resource "azurerm_storage_account" "function_app" {
  name                = "sa${random_id.environment.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  public_network_access_enabled = false

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  local_user_enabled        = false
  shared_access_key_enabled = false

  tags = var.tags
}

resource "azurerm_private_endpoint" "sa_blob_pe" {
  name                = format("pe-%s-blob", azurerm_storage_account.function_app.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.blob.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-blob", azurerm_storage_account.function_app.name)
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_table_pe" {
  name                = format("pe-%s-table", azurerm_storage_account.function_app.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.table.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-table", azurerm_storage_account.function_app.name)
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_queue_pe" {
  name                = format("pe-%s-queue", azurerm_storage_account.function_app.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.queue.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-queue", azurerm_storage_account.function_app.name)
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_file_pe" {
  name                = format("pe-%s-file", azurerm_storage_account.function_app.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.file.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-file", azurerm_storage_account.function_app.name)
    private_connection_resource_id = azurerm_storage_account.function_app.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}
