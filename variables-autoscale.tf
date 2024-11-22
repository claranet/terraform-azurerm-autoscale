variable "target_resource_id" {
  description = "ID of the resource to apply the autoscale setting to."
  type        = string
}

variable "resource_group_name" {
  description = "Custom resource group name to attach autoscale configuration to. Target resource group by default."
  type        = string
  default     = null
}

variable "profile" {
  description = "One or more (up to 20) autoscale profile blocks."
  type = map(object({
    capacity = object({
      default = number
      minimum = optional(number, 1)
      maximum = optional(number, 5)
    })
    rules = optional(list(object({
      metric_trigger = object({
        metric_name              = string
        metric_resource_id       = string
        operator                 = string
        statistic                = string
        time_aggregation         = string
        time_grain               = string
        time_window              = string
        threshold                = number
        metric_namespace         = optional(string)
        divide_by_instance_count = optional(bool)
        dimensions = optional(list(object({
          name     = string
          operator = string
          values   = list(string)
        })), [])
      })
      scale_action = object({
        cooldown  = string
        direction = string
        type      = string
        value     = number
      })
    })), [])
    fixed_date = optional(object({
      end      = string
      start    = string
      timezone = string
    }))
    recurrence = optional(object({
      timezone = string
      days     = list(string)
      hours    = list(number)
      minutes  = list(number)
    }))
  }))
}

variable "notification" {
  description = "Manage emailing and webhooks for sending notifications."
  type = object({
    email = optional(object({
      send_to_subscription_administrator    = optional(bool, false)
      send_to_subscription_co_administrator = optional(bool, false)
      custom_emails                         = optional(list(string))
    }))
    webhooks = optional(list(object({
      service_uri = string
      properties  = optional(map(string))
    })), [])
  })
  default = null
}

variable "autoscale_enabled" {
  description = "Specifies whether automatic scaling is enabled for the target resource."
  type        = bool
  default     = true
}
