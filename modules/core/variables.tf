variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "core_folder_id" {
  description = ""
  type        = string
}

variable "gcp_region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "environment" {
  description = ""
  type        = string
}

variable "network_project_name" {
  description = "project name"
  type        = string
}

variable "security_project_name" {
  description = "project name"
  type        = string
}

variable "project_services" {
  description = "Service APIs enabled by default in core projects."
  type        = set(string)
}

variable "jit_services" {
  description = ""
  type        = set(string)
}

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}

variable "groups" {
  description = "Map of short group name to full google group name"
  type        = map(string)
}

variable "core_cicd_sa_email" {
  description = ""
  type        = string
}

variable "app_project_names" {
  description = ""
  type        = set(string)
}

variable "app_services" {
  description = "Service APIs enabled by default in the app-environment projects."
  type        = list(string)
}

variable "app_jit_services" {
  description = ""
  type        = set(string)
}

variable "app_roles" {
  description = ""
  type        = set(string)
}

variable "app_subnet_cidrs" {
  type = map(string)
}
