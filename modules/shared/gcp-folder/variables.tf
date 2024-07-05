variable "folder_name" {
  type = string
}

variable "parent_folder_id" {
  type = string
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
}
