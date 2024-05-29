output "id" {
  description = "Project id."
  value       = google_project.this.id
}

output "name" {
  description = "Project name."
  value       = google_project.this.name
}

output "number" {
  description = "Project number."
  value       = google_project.this.number
}

output "subnet" {
  description = ""
  value       = google_compute_subnetwork.app_subnet.id
}
