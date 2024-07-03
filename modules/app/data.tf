data "google_compute_network" "shared_network" {
  name    = var.host_vpc
  project = var.host_vpc
}

data "google_compute_subnetwork" "env_subnet" {
  name    = var.app_subnet
  project = var.host_vpc
  region  = var.gcp_region
}
