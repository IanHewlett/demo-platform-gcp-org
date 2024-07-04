variable "project_name" {
  description = "project name"
  type        = string
}

variable "workflow_sa" {
  type = string
}

variable "region" {
  type        = string
  description = "Google Cloud region"
}

variable "trigger_buckets" {
  type        = list(string)
  description = "List of bucket names for creating EventArc triggers"
}
