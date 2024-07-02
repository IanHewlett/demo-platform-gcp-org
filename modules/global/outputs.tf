output "project_folder_id" {
  description = "folder id"
  value       = google_folder.global.id
}

output "core_folder_id" {
  description = "folder id"
  value       = google_folder.core.id
}

output "cicd_sa_email" {
  value = module.core_cicd_service_account.email
}
