resource "google_compute_global_address" "static_ip_address" {
  name    = "static-ip-address"
  project = var.project_name
}
