variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "folder_id" {
  description = ""
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_services" {
  description = "Service APIs enabled by default in the app-environment projects."
  type        = set(string)
}

variable "jit_services" {
  description = ""
  type        = set(string)
}
