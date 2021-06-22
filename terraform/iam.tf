resource "azurerm_user_assigned_identity" "appgwmsi" {
  name                = "${var.base_name}-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}