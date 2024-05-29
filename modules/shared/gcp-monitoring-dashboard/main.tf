resource "google_monitoring_dashboard" "dashboard" {
  project = var.project_name

  dashboard_json = templatefile("${path.module}/dashboard.json", {
    environment = var.environment
  })
}
