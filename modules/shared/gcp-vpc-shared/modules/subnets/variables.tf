variable "project_name" {
  description = "project name"
  type        = string
}

variable "gcp_region" {
  description = ""
  type        = string
}

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}

variable "network_link" {
  description = ""
  type        = string
}
