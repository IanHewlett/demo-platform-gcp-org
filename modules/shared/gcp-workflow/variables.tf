variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_number" {
  description = "project number"
  type        = string
}

variable "region" {
  type        = string
  description = "Google Cloud region"
}

variable "trigger_buckets" {
  type        = list(string)
  description = "List of bucket names for creating EventArc triggers"
}

variable "service_account_roles" {
  type        = list(string)
  description = "Roles for the runtime service account"
}
