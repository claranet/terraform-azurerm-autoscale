module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
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
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name

  vnet_cidr = ["192.168.0.0/21"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["192.168.0.0/24"]
}


module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
}


module "linux-scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name

  admin_username = "myusername"
  ssh_public_key = var.ssh_public_key

  vms_sku = "Standard_B2s"

  subnet_id = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}

module "autoscale" {
  source  = "claranet/autoscale/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name

  target_resource_id = module.linux-scaleset.scale_set_id

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
            metric_resource_id = module.linux-scaleset.scale_set_id
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
            metric_resource_id = module.linux-scaleset.scale_set_id
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

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
}
