resource "random_pet" "db_user" {
  length = 2
}

resource "google_sql_user" "db_user" {
  project  = var.project_name
  name     = google_secret_manager_secret_version.db_user_version.secret_data
  instance = google_sql_database_instance.application_db_instance.name
  password = google_secret_manager_secret_version.db_pass_version.secret_data
}

resource "google_secret_manager_secret" "db_user" {
  project   = var.project_name
  secret_id = "db-user-${var.service_name}"

  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_user_version" {
  secret      = google_secret_manager_secret.db_user.id
  secret_data = random_pet.db_user.id
}

resource "google_secret_manager_secret_iam_member" "db_user_accessor" {
  project   = var.project_name
  secret_id = google_secret_manager_secret.db_user.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account}"
}
