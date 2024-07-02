output "email" {
  description = "Service account email"
  value       = google_service_account.this.email
}

output "account_id" {
  description = "Service account id"
  value       = google_service_account.this.account_id
}

output "sa_member" {
  value = "serviceAccount:${google_service_account.this.email}"
}

output "name" {
  value = google_service_account.this.name
}
