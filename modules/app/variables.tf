variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "app_folder_id" {
  description = ""
  type        = string
}

variable "region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "environment" {
  description = ""
  type        = string
}

variable "app_project_name" {
  description = "project name"
  type        = string
}

variable "host_vpc" {
  description = ""
  type        = string
}

variable "app_roles" {
  description = ""
  type        = set(string)
}

variable "app_services" {
  description = "Service APIs enabled by default in the app-environment projects."
  type        = list(string)
}

variable "app_subnet" {
  description = ""
  type        = string
}

variable "domains" {
  type        = list(string)
  description = "List of domain names for certificate provisioning"
}
