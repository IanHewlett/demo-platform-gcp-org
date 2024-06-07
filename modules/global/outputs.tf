output "project_folder_id" {
  description = "folder id"
  value       = google_folder.global.id
}

output "core_folder_id" {
  description = "folder id"
  value       = google_folder.core.id
}

output "cicd_sa_email" {
  value = google_service_account.core_service_account.email
}
