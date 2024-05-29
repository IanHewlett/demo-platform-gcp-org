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

variable "project_services" {
  description = "Service APIs enabled by default in core projects."
  type        = list(string)
}

variable "jit_services" {
  description = ""
  type        = set(string)
}

variable "cicd_project_name" {
  description = "project name"
  type        = string
}

variable "core_roles" {
  description = ""
  type        = set(string)
}
