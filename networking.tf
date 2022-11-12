resource "azurerm_public_ip" "this" {
  count               = var.publicly_accessible ? 1 : 0
  name                = "${var.name}-${var.env}-pip"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"

  tags = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-${var.env}-vnet"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = var.vnet_address_space

  tags = local.tags
}

resource "azurerm_subnet" "this" {
  name                 = "${var.name}-${var.env}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.vnet_address_space
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.name}-${var.env}-nsg"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  tags                = local.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.nsg_rules

  network_security_group_name = azurerm_network_security_group.this.name
  resource_group_name         = local.resource_group_name

  name                       = each.key
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-${var.env}-nic"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "${var.name}-${var.env}-ipconfig"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = var.publicly_accessible ? azurerm_public_ip.this[0].id : null
  }

  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
