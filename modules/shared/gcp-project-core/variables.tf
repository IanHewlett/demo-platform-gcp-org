variable "billing_account_id" {
  description = "Billing account id used as to create projects."
  type        = string
}

variable "folder_id" {
  description = "folder id"
  type        = string
}

variable "project_name" {
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
