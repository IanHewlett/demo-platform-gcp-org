resource "random_password" "db_pass" {
  length  = 40
  special = false
}

resource "google_secret_manager_secret" "db_pass" {
  project   = var.project_name
  secret_id = "db-pass-${var.service_name}"

  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_pass_version" {
  secret      = google_secret_manager_secret.db_pass.id
  secret_data = random_password.db_pass.result
}

resource "google_secret_manager_secret_iam_member" "db_pass_accessor" {
  project   = var.project_name
  secret_id = google_secret_manager_secret.db_pass.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account}"
}
