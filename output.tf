output "public_ip" {
  description = "The public IP address of the VM, if publicly accessible"
  value       = var.publicly_accessible ? azurerm_public_ip.this[0].ip_address : null
  sensitive   = true
}

output "private_ip" {
  description = "The private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "public_key_secret_id" {
  description = "The reference to the public key in the keyvault, if a public key was NOT provided"
  value       = var.admin_public_key == null ? azurerm_key_vault_secret.publickey[0].id : null
}

output "private_key_secret_id" {
  description = "The reference to the private key in the keyvault, if a public key was NOT provided"
  value       = var.admin_public_key == null ? azurerm_key_vault_secret.privatekey[0].id : null
}

output "username_secret_id" {
  description = "The reference to the username in the keyvault, if a username was NOT provided"
  value       = var.admin_username == null ? azurerm_key_vault_secret.username[0].id : null
}
