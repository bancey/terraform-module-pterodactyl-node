resource "azurerm_key_vault" "this" {
  name                = "${var.name}-${var.env}-kv"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy = local.all_kv_policies

  tags = local.tags
}

resource "tls_private_key" "this" {
  count     = var.admin_public_key == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "privatekey" {
  count        = var.admin_public_key == null ? 1 : 0
  name         = "${var.name}-${var.env}-privatekey"
  key_vault_id = azurerm_key_vault.this.id
  value        = tls_private_key.this[0].private_key_openssh
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "publickey" {
  count        = var.admin_public_key == null ? 1 : 0
  name         = "${var.name}-${var.env}-publickey"
  key_vault_id = azurerm_key_vault.this.id
  value        = tls_private_key.this[0].public_key_openssh
  tags         = local.tags
}

resource "random_string" "username" {
  count = var.admin_username == null ? 1 : 0
  keepers = {
    resource_group = local.resource_group_name
  }

  length  = 12
  special = false
}

resource "azurerm_key_vault_secret" "username" {
  count        = var.admin_username == null ? 1 : 0
  name         = "${var.name}-${var.env}-username"
  key_vault_id = azurerm_key_vault.this.id
  value        = random_string.username[0].result
  tags         = local.tags
}
