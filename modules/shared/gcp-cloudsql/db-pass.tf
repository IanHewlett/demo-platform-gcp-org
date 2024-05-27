resource "random_password" "api_db_pass" {
  length  = 40
  special = false
}

resource "google_secret_manager_secret" "api_db_pass" {
  project   = var.project_name
  secret_id = "api-db-pass"

  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "api_db_pass_version" {
  secret      = google_secret_manager_secret.api_db_pass.id
  secret_data = random_password.api_db_pass.result
}

resource "google_secret_manager_secret_iam_member" "db_pass_accessor" {
  project   = var.project_name
  secret_id = google_secret_manager_secret.api_db_pass.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.api_service_account}"
}
