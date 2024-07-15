resource "google_compute_region_health_check" "sftp" {
  provider = google-beta

  project             = var.project
  region              = var.region
  name                = "${var.environment}-sftp-healthcheck"
  timeout_sec         = 5
  unhealthy_threshold = 2

  tcp_health_check {
    port = "22"
  }

  log_config {
    enable = true
  }
}
