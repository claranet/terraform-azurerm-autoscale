# Azure Autoscale
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/autoscale/azurerm/)

This Terraform module manage autoscaling configuration on a given Azure resource.

This module comes with a default profile working with Virtual Machine Scale Sets and App Service Plans based on Azure Monitor CPU and memory metrics. Also, this module allows to override it with custom profiles and rules.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment         = var.environment
  client_name         = var.client_name
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  vnet_cidr = ["192.168.0.0/21"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name
  subnet_cidr_list     = ["192.168.0.0/24"]
}

module "linux_scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.name

  admin_username = "myusername"
  ssh_public_key = var.ssh_public_key

  vms_size = "Standard_B2s"

  subnet_id = module.subnet.id

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
  resource_group_name = module.rg.name

  target_resource_id = module.linux_scaleset.id

  autoscale_profile = {
    "default" = {
      capacity = {
        default = 2
        minimum = 2
        maximum = 5
      }
      rules = [
        {
          metric_trigger = {
            metric_name        = "Percentage CPU"
            metric_resource_id = module.linux_scaleset.id
            time_grain         = "PT1M"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            statistic          = "Average"
            operator           = "GreaterThanOrEqual"
            threshold          = 75
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
            metric_resource_id = module.linux_scaleset.id
            time_grain         = "PT1M"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            statistic          = "Average"
            operator           = "LessThan"
            threshold          = 25
            metric_namespace   = "microsoft.compute/virtualmachinescalesets"
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
| azurecaf | ~> 1.2.28 |
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_autoscale_setting.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurecaf_name.autoscale](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autoscale\_enabled | Specifies whether automatic scaling is enabled for the target resource. | `bool` | `true` | no |
| autoscale\_profile | One or more (up to 20) autoscale profile blocks. | <pre>map(object({<br/>    capacity = object({<br/>      default = number<br/>      minimum = optional(number, 1)<br/>      maximum = optional(number, 5)<br/>    })<br/>    rules = optional(list(object({<br/>      metric_trigger = object({<br/>        metric_name              = string<br/>        metric_resource_id       = string<br/>        operator                 = string<br/>        statistic                = string<br/>        time_aggregation         = string<br/>        time_grain               = string<br/>        time_window              = string<br/>        threshold                = number<br/>        metric_namespace         = optional(string)<br/>        divide_by_instance_count = optional(bool)<br/>        dimensions = optional(list(object({<br/>          name     = string<br/>          operator = string<br/>          values   = list(string)<br/>        })), [])<br/>      })<br/>      scale_action = object({<br/>        cooldown  = string<br/>        direction = string<br/>        type      = string<br/>        value     = number<br/>      })<br/>    })), [])<br/>    fixed_date = optional(object({<br/>      end      = string<br/>      start    = string<br/>      timezone = string<br/>    }))<br/>    recurrence = optional(object({<br/>      timezone = string<br/>      days     = list(string)<br/>      hours    = list(number)<br/>      minutes  = list(number)<br/>    }))<br/>  }))</pre> | n/a | yes |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom name for Autoscale setting, generated if not set. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your autoscale setting. | `map(string)` | `{}` | no |
| location | Azure location/region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| notification | Manage emailing and webhooks for sending notifications. | <pre>object({<br/>    email = optional(object({<br/>      send_to_subscription_administrator    = optional(bool, false)<br/>      send_to_subscription_co_administrator = optional(bool, false)<br/>      custom_emails                         = optional(list(string))<br/>    }))<br/>    webhooks = optional(list(object({<br/>      service_uri = string<br/>      properties  = optional(map(string))<br/>    })), [])<br/>  })</pre> | `null` | no |
| resource\_group\_name | Custom resource group name to attach autoscale configuration to. Target resource group by default. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| target\_resource\_id | ID of the resource to apply the autoscale setting to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the Azure Autoscale setting. |
| module\_diagnostics | Diagnostics Settings module output. |
| name | Name of the Azure Autoscale setting. |
| resource | Azure Autoscale setting resource object. |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation - Virtual Machine Scale Sets Autoscale: [docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview)

Microsoft Azure documentation - App Services Autoscale: [docs.microsoft.com/en-us/azure/app-service/manage-scale-up](https://docs.microsoft.com/en-us/azure/app-service/manage-scale-up)

Microsoft Azure documentation - Metrics supported: [docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported)
