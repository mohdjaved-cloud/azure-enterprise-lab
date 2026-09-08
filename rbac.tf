resource "azurerm_role_assignment" "application_reader" {
  scope                            = azurerm_resource_group.lab.id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_linux_virtual_machine.application.identity[0].principal_id
  skip_service_principal_aad_check = true
}