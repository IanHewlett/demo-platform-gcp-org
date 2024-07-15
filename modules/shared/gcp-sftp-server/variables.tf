variable "environment" {
  type        = string
  description = "Application environment"
}

variable "users" {
  type        = map(map(string))
  description = "Map of {user = { folder = bucket }}"
}

variable "private_network" {
  type        = string
  description = "Fully qualified resource name of the VPC network"
}

variable "project" {
  type        = string
  description = "Google Cloud Project"
}

variable "region" {
  type        = string
  description = "Google Cloud Region"
}

variable "subnet" {
  type        = string
  description = "Fully qualified resource name of the environment subnet"
}

variable "zone" {
  type        = string
  description = "Google Cloud Compute Zone"
}

variable "sshKey" {
  type        = string
  description = "Public SSH Key"
}

variable "sftp_host_sa" {
  type = string
}
