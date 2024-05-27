variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "project_folder_id" {
  #description = ""
  type = string
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

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}
