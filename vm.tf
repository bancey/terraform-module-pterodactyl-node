resource "azurerm_linux_virtual_machine" "this" {
  name                            = "${var.name}-${var.env}-vm"
  location                        = local.resource_group_location
  resource_group_name             = local.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username == null ? random_string.username[0].result : var.admin_username
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = var.admin_username == null ? random_string.username[0].result : var.admin_username
    public_key = var.admin_public_key == null ? tls_private_key.this[0].public_key_openssh : var.admin_public_key
  }

  os_disk {
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_type
    disk_size_gb         = var.vm_os_disk_size_gb
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  dynamic "identity" {
    for_each = var.enable_aad_login ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
  count              = var.vm_shutdown_schedule == null ? 0 : 1
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  location           = local.resource_group_location
  enabled            = var.vm_shutdown_schedule.enabled

  daily_recurrence_time = var.vm_shutdown_schedule.time
  timezone              = var.vm_shutdown_schedule.timezone

  notification_settings {
    enabled = false
  }
}
