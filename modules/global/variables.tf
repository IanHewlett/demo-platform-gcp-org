variable "root_folder_num" {
  description = "root folder number"
  type        = string
}

variable "global_folder_name" {
  description = ""
  type        = string
}

variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "cicd_project_name" {
  description = "project name"
  type        = string
}

variable "groups" {
  description = "Map of short group name to full google group name"
  type        = map(string)
}

variable "gcp_region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "environment" {
  description = ""
  type        = string
}

variable "bucket_prefix" {
  type = string
}
