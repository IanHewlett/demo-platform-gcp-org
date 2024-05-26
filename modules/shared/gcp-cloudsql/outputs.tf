output "cloudsql_instance_connection" {
  value = google_sql_database_instance.application_db_instance.connection_name
}

output "db_name" {
  value = google_sql_database.application_db.name
}

output "db_user_secret" {
  value = google_secret_manager_secret.api_db_user.id
}

output "db_pass_secret" {
  value = google_secret_manager_secret.api_db_pass.id
}
