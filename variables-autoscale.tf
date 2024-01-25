variable "target_resource_id" {
  description = "ID of the resource to apply the autoscale setting to."
  type        = string
}

variable "resource_group_name" {
  description = "Custom resource group name to attach autoscale configuration to. Target resource group by default."
  type        = string
  default     = null
}

variable "autoscale_profile" {
  description = "One or more (up to 20) autoscale profile blocks."
  type = map(object({
    capacity = object({
      default = number
      minimum = optional(number, 1)
      maximum = optional(number, 5)
    })
    rule = optional(list(object({
      metric_trigger = optional(any)
      scale_action = optional(object({
        cooldown  = string
        direction = string
        type      = string
        value     = string
      }))
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
  default = null
}

variable "notification" {
  description = "Manage emailing and webhooks for sending notifications."
  type        = any
  default     = {}
}

variable "enable_autoscale" {
  description = "Specifies whether automatic scaling is enabled for the target resource."
  type        = bool
  default     = true
}
