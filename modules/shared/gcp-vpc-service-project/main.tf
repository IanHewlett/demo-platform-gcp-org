resource "google_compute_subnetwork" "app_subnet" {
  project                    = var.host_vpc
  name                       = "${var.project_name}-subnet"
  description                = "Terraform-managed."
  ip_cidr_range              = var.app_subnet_cidr
  region                     = var.gcp_region
  network                    = var.host_vpc
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_subnetwork_iam_binding" "subnet_binding" {
  project    = var.host_vpc
  region     = var.gcp_region
  subnetwork = google_compute_subnetwork.app_subnet.id
  role       = "roles/compute.networkUser"

  members = var.computeNetworkUsers
}
