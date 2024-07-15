resource "google_compute_address" "sftp" {
  project      = var.project
  region       = var.region
  name         = "sftp-static"
  address_type = "EXTERNAL"
}
