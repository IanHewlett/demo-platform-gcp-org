output "service_runner_email" {
  value = google_service_account.service_runner.email
}

output "cloud_run_service_name" {
  value = google_cloud_run_v2_service.service.name
}

output "cloud_run_service_uri" {
  value = google_cloud_run_v2_service.service.uri
}
