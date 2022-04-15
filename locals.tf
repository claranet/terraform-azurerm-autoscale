locals {
  target_resource_family = lower(element(split("/", var.target_resource_id), 7))

  autoscale_profile_scaleset = coalesce(var.autoscale_profile,
    {
      "default" = {
        capacity = {
          default = 2
          minimum = 2
          maximum = var.default_autoscale_profile_maximum_capacity
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
  )

  default_autoscale_profile = coalesce(var.autoscale_profile,
    {
      "default" = {
        capacity = {
          default = 2
          minimum = 2
          maximum = var.default_autoscale_profile_maximum_capacity
        }
        rule = [
          {
            metric_trigger = {
              metric_name        = "CpuPercentage"
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
              metric_name        = "MemoryPercentage"
              metric_resource_id = var.target_resource_id
              time_grain         = "PT1M"
              time_window        = "PT5M"
              time_aggregation   = "Average"
              statistic          = "Average"
              operator           = "GreaterThanOrEqual"
              threshold          = 90
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
              metric_name        = "CpuPercentage"
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
  })

  autoscale_profile = local.target_resource_family == lower("virtualMachineScaleSets") ? local.autoscale_profile_scaleset : local.default_autoscale_profile
}
