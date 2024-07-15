resource "google_sql_database_instance" "application_db_instance" {
  provider = google-beta

  project             = var.project_name
  region              = var.gcp_region
  name                = var.instance_name
  database_version    = "POSTGRES_15"
  deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.private_network
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
  name     = var.database_name
  instance = google_sql_database_instance.application_db_instance.name
}
