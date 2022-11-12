variable "existing_resource_group_name" {
  description = "Name of an existing resourcegroup to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy resources into"
  type        = string
  default     = "uksouth"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = null
}

variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
  default     = ["10.100.0.0/16"]
}

variable "env" {
  description = "The name of the environment"
  type        = string
  default     = "prod"
}

variable "kv_policies" {
  description = "Policiy to apply to the keyvault"
  type = set(object({
    tenant_id               = string
    object_id               = string
    application_id          = string
    certificate_permissions = list(string)
    key_permissions         = list(string)
    storage_permissions     = list(string)
    secret_permissions      = list(string)
  }))
  default = []
}


variable "admin_public_key" {
  description = "Public key to use for the admin account. If not provided, a new key will be generated"
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Username for the admin account. If not provided, a random username will be generated"
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "Whether the node should be publicly accessible"
  type        = bool
  default     = false
}

variable "existing_public_ip_id" {
  description = "The ID of an existing public IP to use for the node"
  type        = string
  default     = null
}

variable "nsg_rules" {
  description = "Rule to apply to the network security group"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "vm_os_disk_caching" {
  description = "The caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "vm_os_disk_type" {
  description = "The type of the OS disk"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "vm_os_disk_size_gb" {
  description = "The size of the OS disk"
  type        = number
  default     = 128
}

variable "vm_auto_shutdown_time" {
  description = "The time at which the VM should be automatically shutdown"
  type        = string
  default     = "0000"
}

variable "vm_auto_shutdown_timezone" {
  description = "The timezone for the auto shutdown time"
  type        = string
  default     = "GMT Standard Time"
}

variable "vm_domain_name" {
  description = "The domain name to use for the VM, if specified the VM will attempt to generate SSL certificates using certbot."
  type        = string
  default     = null
}
