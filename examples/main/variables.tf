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

variable "azure_region" {
  description = "Azure region"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VMSS"
  type        = string
}
