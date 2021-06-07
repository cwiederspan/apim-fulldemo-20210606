# resource "azurerm_network_profile" "aciprofile" {
#   name                = "${var.base_name}-profile"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   container_network_interface {
#     name = "eth0"

#     ip_configuration {
#       name      = "ipconfigprofile"
#       subnet_id = azurerm_subnet.bastion.id
#     }
#   }
# }

# resource "azurerm_container_group" "bastion" {
#   name                = "${var.base_name}-aci"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   ip_address_type     = "Private"
#   os_type             = "Linux"

#   network_profile_id  = azurerm_network_profile.aciprofile.id

#   container {
#     name   = "bastion"
#     image  = "radial/busyboxplus:curl"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 80
#       protocol = "TCP"
#     }
#   }
# }
