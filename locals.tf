locals {
  target_resource_family = lower(element(split("/", var.target_resource_id), 7))

  resource_group_name = coalesce(var.resource_group_name, element(split("/", var.target_resource_id), 4))

  autoscale_profile_scaleset_default = {
    "default" = {
      capacity = {
        default = 2
        minimum = 2
        maximum = 5
      }
      rule = [
        {
          metric_trigger = {
            metric_name        = "Percentage CPU"
            metric_resource_id = var.target_resource_id
            time_grain         = "PT1M"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            statistic          = "Average"
            operator           = "GreaterThanOrEqual"
            threshold          = 75
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
            metric_resource_id = var.target_resource_id
            time_grain         = "PT1M"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            statistic          = "Average"
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

  autoscale_profile = local.target_resource_family == lower("virtualMachineScaleSets") ? coalesce(var.autoscale_profile, local.autoscale_profile_scaleset_default) : var.autoscale_profile
}
