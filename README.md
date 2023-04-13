# Azure Autoscale
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/autoscale/azurerm/)

This Terraform module manage autoscaling configuration on a given Azure resource.

This module comes with a default profile working with Virtual Machine Scale Sets and App Service Plans based on Azure Monitor CPU and memory metrics. Also, this module allows to override it with custom profiles and rules.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment         = var.environment
  client_name         = var.client_name
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  vnet_cidr = ["192.168.0.0/21"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["192.168.0.0/24"]
}


module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
}

module "linux_scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name

  admin_username = "myusername"
  ssh_public_key = var.ssh_public_key

  vms_size = "Standard_B2s"

  subnet_id = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id
}

module "autoscale" {
  source  = "claranet/autoscale/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  target_resource_id = module.linux_scaleset.scale_set_id

  autoscale_profile = {
    "my-profile" = {
      capacity = {
        default = 1
        minimum = 1
        maximum = 1
      }
      rule = [
        {
          metric_trigger = {
            metric_name        = "Percentage CPU"
            metric_resource_id = module.linux_scaleset.scale_set_id
            time_grain         = "PT1M"
            statistic          = "Average"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            operator           = "GreaterThanOrEqual"
            threshold          = 70
            metric_namespace   = "microsoft.compute/virtualmachinescalesets"
          }

          scale_action = {
            direction = "Increase"
            type      = "ChangeCount"
            value     = "1"
            cooldown  = "PT1M"
          }
        },
        {
          metric_trigger = {
            metric_name        = "Percentage CPU"
            metric_resource_id = module.linux_scaleset.scale_set_id
            time_grain         = "PT1M"
            statistic          = "Average"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            operator           = "LessThan"
            threshold          = 25
          }

          scale_action = {
            direction = "Decrease"
            type      = "ChangeCount"
            value     = "1"
            cooldown  = "PT1M"
          }
        }
      ]
    }
  }

  notification = {
    email = {
      custom_emails = ["myemail@example.com"]
    }
  }

  logs_destinations_ids = [module.run.log_analytics_workspace_id]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | >= 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_autoscale_setting.autoscale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurecaf_name.autoscale](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autoscale\_profile | One or more (up to 20) autoscale profile blocks. | `any` | `null` | no |
| client\_name | Name of client | `string` | n/a | yes |
| custom\_autoscale\_setting\_name | Custom Autoscale setting name | `string` | `""` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_autoscale\_profile\_maximum\_capacity | Maximum capacity for the default profile of Autoscale. | `number` | `5` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| enable\_autoscale | Specifies whether automatic scaling is enabled for the target resource. | `bool` | `true` | no |
| environment | Name of application's environnement | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your autoscale setting | `map(string)` | `{}` | no |
| location | Azure location for Key Vault. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| notification | Manage emailing and webhooks for sending notifications. | `any` | `{}` | no |
| resource\_group\_name | Name of the application ressource group, herited from infra module | `string` | n/a | yes |
| stack | Name of application stack | `string` | n/a | yes |
| target\_resource\_id | ID of the resource to apply the autoscale setting to. | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_autoscale_setting_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscale\_setting\_id | Azure Autoscale setting ID |
| autoscale\_setting\_name | Azure Autoscale setting name |
| autoscale\_setting\_profile | Azure Autoscale setting profile |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation - Virtual Machine Scale Sets Autoscale: [docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview)

Microsoft Azure documentation - App Services Autoscale: [docs.microsoft.com/en-us/azure/app-service/manage-scale-up](https://docs.microsoft.com/en-us/azure/app-service/manage-scale-up)

Microsoft Azure documentation - Metrics supported: [docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported)
