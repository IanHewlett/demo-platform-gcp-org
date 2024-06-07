variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_number" {
  description = "project number"
  type        = string
}

variable "app_roles" {
  description = ""
  type        = set(string)
}

variable "groups" {
  description = "Map of short group name to full google group name"
  type        = map(string)
}

variable "core_sa_email" {
  type = string
}
