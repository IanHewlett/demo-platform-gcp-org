resource "random_pet" "api_db_user" {
  length = 2
}

resource "google_sql_user" "api_db_user" {
  project  = var.project_name
  name     = google_secret_manager_secret_version.api_db_user_version.secret_data
  instance = google_sql_database_instance.application_db_instance.name
  password = google_secret_manager_secret_version.api_db_pass_version.secret_data
}

resource "google_secret_manager_secret" "api_db_user" {
  project   = var.project_name
  secret_id = "api-db-user"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "api_db_user_version" {
  secret      = google_secret_manager_secret.api_db_user.id
  secret_data = random_pet.api_db_user.id
}

resource "google_secret_manager_secret_iam_member" "db_user_accessor" {
  project   = var.project_name
  secret_id = google_secret_manager_secret.api_db_user.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.api_service_account}"
}
