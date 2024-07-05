output "project_folder_id" {
  description = "folder id"
  value       = module.global_folder.folder_id
}

output "core_folder_id" {
  description = "folder id"
  value       = module.core_folder.folder_id
}

output "cicd_sa_email" {
  value = module.core_cicd_service_account.email
}
