output "app_folder_id" {
  description = "folder id"
  value       = module.app_folder.folder_id
}

output "network_project_name" {
  description = "network project name"
  value       = module.network_project.name
}

output "security_project_name" {
  description = "security project name"
  value       = module.security_project.name
}

output "host_vpc_name" {
  description = "host vpc name"
  value       = module.shared_vpc.host_vpc_name
}
