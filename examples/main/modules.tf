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
