resource "google_monitoring_notification_channel" "alert_recipients" {
  for_each = toset(var.alert_recipients)

  type         = "email"
  display_name = each.value
  force_delete = true
  project      = var.project

  labels = {
    email_address = each.value
  }
}

resource "google_monitoring_alert_policy" "cloudsql_high_cpu" {
  display_name = "CloudSQL Instance - High CPU Utilization"
  combiner     = "OR"
  severity     = "ERROR"
  project      = var.project

  notification_channels = [
    for channel in google_monitoring_notification_channel.alert_recipients : channel.id
  ]

  conditions {
    display_name = "CloudSQL Instance - High CPU Utilization"

    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "3600s"
      threshold_value = 0.8

      filter = <<EOT
      resource.type = "cloudsql_database" AND 
      metric.type = "cloudsql.googleapis.com/database/cpu/utilization"
      EOT

      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  documentation {
    subject   = "${upper(var.environment)}: CloudSQL Instance - High CPU Utilization"
    mime_type = "text/markdown"

    content = <<EOT
This alert fires when the CPU utilization on any CloudSQL instance rises above 80% for 5 minutes or more.
    EOT
  }

  alert_strategy {
    auto_close = "604800s"
  }
}

resource "google_monitoring_alert_policy" "cloudsql_postgresql_connections" {
  display_name = "CloudSQL Database - PostgreSQL Connections"
  combiner     = "OR"
  enabled      = true
  severity     = "ERROR"
  project      = var.project

  notification_channels = [
    for channel in google_monitoring_notification_channel.alert_recipients : channel.id
  ]

  conditions {
    display_name = "CloudSQL Database - PostgreSQL Connections"

    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "3600s"
      threshold_value = 80

      filter = <<EOT
      resource.type = "cloudsql_database" AND 
      metric.type = "cloudsql.googleapis.com/database/postgresql/num_backends"
      EOT

      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["resource.label.database_id"]
        per_series_aligner   = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  documentation {
    subject   = "${upper(var.environment)}: CloudSQL Database - PostgreSQL Connections"
    mime_type = "text/markdown"

    content = <<EOT
This alert fires when the average connections to any database exceed 80 for 5 minutes.
    EOT
  }

  alert_strategy {
    auto_close = "604800s"
  }
}
