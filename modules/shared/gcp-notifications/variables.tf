variable "alert_recipients" {
  type        = list(string)
  description = "List of email addresses to receive alerts."
}

variable "environment" {
  type        = string
  description = "Application environment"
}

variable "project" {
  type        = string
  description = "Google Cloud Project"
}
