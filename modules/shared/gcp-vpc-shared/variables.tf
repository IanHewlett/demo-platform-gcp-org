variable "network_project_name" {
  description = "project name"
  type        = string
}

variable "security_project_name" {
  description = "project name"
  type        = string
}

variable "region" {
  description = "Region for resources to be located in"
}

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}
