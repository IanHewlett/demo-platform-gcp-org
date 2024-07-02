variable "project_id" {
  type        = string
  description = "Project id where service account will be created"
}

variable "account_id" {
  type        = string
  description = "Name of service account"
}

variable "display_name" {
  type        = string
  description = "Display name of the created service account"
}

variable "description" {
  type = string
}

variable "project_roles" {
  type        = list(string)
  description = "Roles to grant to the service account in the specified project"
}
