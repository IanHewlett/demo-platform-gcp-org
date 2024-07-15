resource "google_compute_managed_ssl_certificate" "managed_cert" {
  name    = "managed-cert"
  project = var.project_name

  managed {
    domains = var.domains
  }
}
