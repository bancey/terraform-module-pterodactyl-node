# terraform-module-pterodactyl-node

This module deploys a VM to Azure with a number of different options, and bootstraps it to work as a [Pterodactly node](https://pterodactyl.io/).

## Getting Started

Consuming the module is as simple as adding a `module` block to your IaC configuration, see a basic example below.

<!-- TODO - add example module consumption -->

Once the VM has been deployed you'll need to place the wings config in a file called `config.yml` in the `/etc/pterodactyl` directory.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.30.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~>4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.31.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Resources

| Name | Type |
|------|------|
| [azurerm_dev_test_global_vm_shutdown_schedule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.privatekey](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.publickey](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.customscript](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_string.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_access_ip"></a> [admin\_access\_ip](#input\_admin\_access\_ip) | The IP to allow SSH connections from | `string` | n/a | yes |
| <a name="input_admin_public_key"></a> [admin\_public\_key](#input\_admin\_public\_key) | Public key to use for the admin account. If not provided, a new key will be generated | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Username for the admin account. If not provided, a random username will be generated | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | The name of the environment | `string` | `"prod"` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of an existing resourcegroup to deploy resources into | `string` | `null` | no |
| <a name="input_kv_policies"></a> [kv\_policies](#input\_kv\_policies) | Policiy to apply to the keyvault | <pre>set(object({<br>    tenant_id               = string<br>    object_id               = string<br>    application_id          = string<br>    certificate_permissions = list(string)<br>    key_permissions         = list(string)<br>    storage_permissions     = list(string)<br>    secret_permissions      = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy resources into | `string` | `"uksouth"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the game server | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The number of game servers to deploy | `number` | `1` | no |
| <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules) | Rule to apply to the network security group | <pre>map(object({<br>    priority                   = number<br>    direction                  = string<br>    access                     = string<br>    protocol                   = string<br>    source_port_range          = string<br>    destination_port_range     = string<br>    source_address_prefix      = string<br>    destination_address_prefix = string<br>  }))</pre> | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether the node should be publicly accessible | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `null` | no |
| <a name="input_vm_auto_shutdown_time"></a> [vm\_auto\_shutdown\_time](#input\_vm\_auto\_shutdown\_time) | The time at which the VM should be automatically shutdown | `string` | `"0000"` | no |
| <a name="input_vm_auto_shutdown_timezone"></a> [vm\_auto\_shutdown\_timezone](#input\_vm\_auto\_shutdown\_timezone) | The timezone for the auto shutdown time | `string` | `"GMT Standard Time"` | no |
| <a name="input_vm_domain_name"></a> [vm\_domain\_name](#input\_vm\_domain\_name) | The domain name to use for the VM, if specified the VM will attempt to generate SSL certificates using certbot. | `string` | `null` | no |
| <a name="input_vm_image_offer"></a> [vm\_image\_offer](#input\_vm\_image\_offer) | The offer of the VM image | `string` | n/a | yes |
| <a name="input_vm_image_publisher"></a> [vm\_image\_publisher](#input\_vm\_image\_publisher) | The publisher of the VM image | `string` | n/a | yes |
| <a name="input_vm_image_sku"></a> [vm\_image\_sku](#input\_vm\_image\_sku) | The SKU of the VM image | `string` | n/a | yes |
| <a name="input_vm_image_version"></a> [vm\_image\_version](#input\_vm\_image\_version) | The version of the VM image | `string` | n/a | yes |
| <a name="input_vm_os_disk_caching"></a> [vm\_os\_disk\_caching](#input\_vm\_os\_disk\_caching) | The caching type for the OS disk | `string` | `"ReadWrite"` | no |
| <a name="input_vm_os_disk_size_gb"></a> [vm\_os\_disk\_size\_gb](#input\_vm\_os\_disk\_size\_gb) | The size of the OS disk | `number` | `128` | no |
| <a name="input_vm_os_disk_type"></a> [vm\_os\_disk\_type](#input\_vm\_os\_disk\_type) | The type of the OS disk | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VM to deploy | `string` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space of the virtual network | `list(string)` | <pre>[<br>  "10.100.0.0/16"<br>]</pre> | no |
<!-- END_TF_DOCS -->