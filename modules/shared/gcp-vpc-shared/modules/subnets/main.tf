resource "google_compute_subnetwork" "core_subnet" {
  project                    = var.project_name
  name                       = "core-subnet"
  ip_cidr_range              = var.core_subnet_cidr
  region                     = var.gcp_region
  network                    = var.network_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_subnetwork" "serverless_subnet" {
  project                    = var.project_name
  name                       = "serverless-subnet"
  ip_cidr_range              = var.serverless_subnet_cidr
  region                     = var.gcp_region
  network                    = var.network_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}
