resource "azurerm_role_assignment" "function_app_storage_blob_data_owner" {
  scope                = azurerm_storage_account.function_app.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.fa.identity[0].principal_id
}
