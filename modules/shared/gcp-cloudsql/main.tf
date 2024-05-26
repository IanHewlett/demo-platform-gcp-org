resource "google_sql_database_instance" "application_db_instance" {
  provider = google-beta

  name                = "api-${var.environment}"
  region              = var.region
  database_version    = "POSTGRES_15"
  deletion_protection = false
  project             = var.project_name

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = "projects/${var.shared_network_project}/global/networks/${var.shared_network_project}"
      allocated_ip_range                            = var.allocated_ip_range
      require_ssl                                   = true
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      location                       = "us"
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "00:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

  }
}

resource "google_sql_database" "application_db" {
  project  = var.project_name
  name     = "api-${var.environment}-db"
  instance = google_sql_database_instance.application_db_instance.name
}
