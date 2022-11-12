variable "name" {
  description = "The name of the game server"
  type        = string
}

variable "admin_access_ip" {
  description = "The IP to allow SSH connections from"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM to deploy"
  type        = string
}

variable "vm_image_publisher" {
  description = "The publisher of the VM image"
  type        = string
}

variable "vm_image_offer" {
  description = "The offer of the VM image"
  type        = string
}

variable "vm_image_sku" {
  description = "The SKU of the VM image"
  type        = string
}

variable "vm_image_version" {
  description = "The version of the VM image"
  type        = string
}
