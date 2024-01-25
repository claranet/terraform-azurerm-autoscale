resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = local.autoscale_setting_name
  location            = var.location
  resource_group_name = local.resource_group_name
  target_resource_id  = var.target_resource_id

  enabled = var.enable_autoscale

  dynamic "profile" {
    for_each = local.autoscale_profile
    content {
      name = profile.key

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = try(profile.value.rule, [])
        content {
          metric_trigger {
            metric_name        = lookup(rule.value.metric_trigger, "metric_name")
            metric_resource_id = lookup(rule.value.metric_trigger, "metric_resource_id")
            operator           = lookup(rule.value.metric_trigger, "operator")
            statistic          = lookup(rule.value.metric_trigger, "statistic")
            time_aggregation   = lookup(rule.value.metric_trigger, "time_aggregation")
            time_grain         = lookup(rule.value.metric_trigger, "time_grain")
            time_window        = lookup(rule.value.metric_trigger, "time_window")
            threshold          = lookup(rule.value.metric_trigger, "threshold")
            metric_namespace   = lookup(rule.value.metric_trigger, "metric_namespace", null)
            dynamic "dimensions" {
              for_each = try(lookup(rule.value.metric_trigger, "dimensions"), {})
              content {
                name     = dimensions.name
                operator = dimensions.operator
                values   = dimensions.values
              }
            }
            divide_by_instance_count = lookup(rule.value.metric_trigger, "divide_by_instance_count", null)
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
    for_each = var.notification != {} ? ["notification"] : []
    content {
      email {
        send_to_subscription_administrator    = lookup(var.notification.email, "send_to_subscription_administrator", false)
        send_to_subscription_co_administrator = lookup(var.notification.email, "send_to_subscription_co_administrator", false)
        custom_emails                         = lookup(var.notification.email, "custom_emails", [])
      }
      dynamic "webhook" {
        for_each = try(var.notification.webhook, {})
        content {
          service_uri = webhook.service_uri
          properties  = webhook.properties
        }
      }
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}
