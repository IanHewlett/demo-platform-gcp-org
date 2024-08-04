variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "core_folder_id" {
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

variable "monitoring_project_name" {
  description = "project name"
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

variable "app_project_names" {
  description = ""
  type        = set(string)
}
