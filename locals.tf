locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  target_resource_family = lower(element(split("/", var.target_resource_id), 7))
  cpu_metric_name = tomap({
    # VMSS
    lower("virtualMachineScaleSets") = "Percentage CPU"
    # App Service Plan
    lower("serverFarms") = "CpuPercentage"
  })

  default_autoscale_profile = {
    "default" = {
      capacity = {
        default = 2
        minimum = 2
        maximum = var.default_autoscale_profile_maximum_capacity
      }
      rule = [
        {
          metric_trigger = {
            metric_name        = lookup(local.cpu_metric_name, local.target_resource_family)
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
            metric_name        = lookup(local.cpu_metric_name, local.target_resource_family)
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

  autoscale_profile = coalesce(var.autoscale_profile, local.default_autoscale_profile)
}
