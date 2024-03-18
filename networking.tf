resource "azurerm_public_ip" "this" {
  count               = var.publicly_accessible && var.existing_public_ip == null ? 1 : 0
  name                = "${var.name}-${var.env}-pip"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"

  tags = local.tags
}

data "azurerm_public_ip" "existing" {
  count               = var.existing_public_ip == null ? 0 : 1
  name                = var.existing_public_ip.name
  resource_group_name = var.existing_public_ip.resource_group_name
}

resource "azurerm_virtual_network" "this" {
  count               = var.existing_subnet_id == null ? 1 : 0
  name                = "${var.name}-${var.env}-vnet"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = var.vnet_address_space

  tags = local.tags
}

resource "azurerm_subnet" "this" {
  count                = var.existing_subnet_id == null ? 1 : 0
  name                 = "${var.name}-${var.env}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = var.vnet_address_space
}

resource "azurerm_network_security_group" "this" {
  count               = var.existing_nsg_id == null ? 1 : 0
  name                = "${var.name}-${var.env}-nsg"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  tags                = local.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.existing_nsg_id == null ? var.nsg_rules : {}

  network_security_group_name = var.existing_nsg_id == null ? azurerm_network_security_group.this[0].name : split("/", var.existing_nsg_id)[length(split("/", var.existing_nsg_id)) - 1]
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
    subnet_id                     = var.existing_subnet_id == null ? azurerm_subnet.this[0].id : var.existing_subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = var.publicly_accessible ? var.existing_public_ip == null ? azurerm_public_ip.this[0].id : data.azurerm_public_ip.existing[0].id : null
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "new" {
  count                     = var.existing_subnet_id == null && var.existing_nsg_id == null ? 1 : 0
  subnet_id                 = azurerm_subnet.this[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_subnet_network_security_group_association" "existing" {
  count                     = var.existing_subnet_id != null && var.existing_nsg_id == null ? 1 : 0
  subnet_id                 = var.existing_subnet_id
  network_security_group_id = azurerm_network_security_group.this[0].id
}
