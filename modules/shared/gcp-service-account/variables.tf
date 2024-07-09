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

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
}
