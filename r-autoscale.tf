resource "azurerm_monitor_autoscale_setting" "main" {
  name                = local.name
  location            = var.location
  resource_group_name = local.resource_group_name
  target_resource_id  = var.target_resource_id

  enabled = var.autoscale_enabled

  dynamic "profile" {
    for_each = var.autoscale_profile
    content {
      name = profile.key
      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = profile.value.rules
        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = rule.value.metric_trigger.metric_resource_id
            operator                 = rule.value.metric_trigger.operator
            statistic                = rule.value.metric_trigger.statistic
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_grain               = rule.value.metric_trigger.time_grain
            time_window              = rule.value.metric_trigger.time_window
            threshold                = rule.value.metric_trigger.threshold
            metric_namespace         = rule.value.metric_trigger.metric_namespace
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count

            dynamic "dimensions" {
              for_each = rule.value.metric_trigger.dimensions
              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }

          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }

      dynamic "fixed_date" {
        for_each = profile.value.fixed_date[*]
        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = fixed_date.value.timezone
        }
      }

      dynamic "recurrence" {
        for_each = profile.value.recurrence[*]
        content {
          timezone = recurrence.value.timezone
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }
    }
  }

  dynamic "notification" {
    for_each = var.notification[*]
    content {
      dynamic "email" {
        for_each = notification.value.email[*]
        content {
          send_to_subscription_administrator    = email.value.send_to_subscription_administrator
          send_to_subscription_co_administrator = email.value.send_to_subscription_co_administrator
          custom_emails                         = email.value.custom_emails
        }
      }
      dynamic "webhook" {
        for_each = notification.value.webhooks
        content {
          service_uri = webhook.value.service_uri
          properties  = webhook.value.properties
        }
      }
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_monitor_autoscale_setting.autoscale
  to   = azurerm_monitor_autoscale_setting.main
}
