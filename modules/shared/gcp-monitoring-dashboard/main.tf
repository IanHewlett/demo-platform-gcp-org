resource "google_monitoring_dashboard" "dashboard" {
  project = var.project_name

  dashboard_json = templatefile("${path.module}/files/dashboard.json", {
    environment = var.environment
  })
}
