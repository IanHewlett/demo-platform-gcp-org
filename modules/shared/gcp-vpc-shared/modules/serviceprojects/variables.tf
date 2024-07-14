variable "project_name" {
  description = ""
  type        = string
}

variable "host_vpc" {
  description = ""
  type        = string
}

variable "shared_vpc_service_projects" {
  description = "Shared VPC service projects to register with this host."
  type        = set(string)
}
