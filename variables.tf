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
  description = "Custom Autoscale setting name"
  type        = string
  default     = ""
}

variable "target_resource_id" {
  description = "ID of the resource to apply the autoscale setting to."
  type        = string
}

variable "autoscale_profile" {
  description = "One or more (up to 20) autoscale profile blocks."
  type        = any
  default     = null
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

variable "default_autoscale_profile_maximum_capacity" {
  description = "Maximum capacity for the default profile of Autoscale."
  type        = number
  default     = 5
}

variable "extra_tags" {
  description = "Additional tags to associate with your autoscale setting."
  type        = map(string)
  default     = {}
}

### LOGGING
variable "logs_destinations_ids" {
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
  type        = list(string)
}

variable "logs_categories" {
  description = "Log categories to send to destinations."
  type        = list(string)
  default     = null
}

variable "logs_metrics_categories" {
  description = "Metrics categories to send to destinations."
  type        = list(string)
  default     = null
}

variable "logs_retention_days" {
  description = "Number of days to keep logs on storage account"
  type        = number
  default     = 30
}
