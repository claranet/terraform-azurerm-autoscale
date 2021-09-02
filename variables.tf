variable "client_name" {
  description = "Name of client"
  type        = string
}

variable "environment" {
  description = "Name of application's environnement"
  type        = string
}

variable "stack" {
  description = "Name of application stack"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for Autoscale setting name"
  type        = string
  default     = ""
}

variable "custom_autoscale_setting_name" {
  type        = string
  description = "Custom Autoscale setting name"
  default     = ""
}

variable "target_resource_id" {
  type        = string
  description = "ID of the resource to apply the autoscale setting to."
}

variable "autoscale_profile" {
  type        = any
  description = "One or more (up to 20) autoscale profile blocks."
  default     = null
}

variable "notification" {
  type        = any
  description = "Manage emailing and webhooks for sending notifications."
  default     = {}
}

variable "enable_autoscale" {
  type        = bool
  description = "Specifies whether automatic scaling is enabled for the target resource."
  default     = true
}

variable "extra_tags" {
  description = "Additional tags to associate with your autoscale setting."
  type        = map(string)
  default     = {}
}

### LOGGING
variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
}

variable "logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "logs_retention_days" {
  type        = number
  description = "Number of days to keep logs on storage account"
  default     = 30
}
