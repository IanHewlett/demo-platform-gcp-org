output "app_project_sa_email" {
  value = google_service_account.app_service_account.email
}

output "app_project_sa_member" {
  value = "serviceAccount:${google_service_account.app_service_account.email}"
}
