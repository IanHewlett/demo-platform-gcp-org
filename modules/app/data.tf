data "google_compute_network" "shared_network" {
  name    = var.host_vpc
  project = var.host_vpc
}

data "google_compute_subnetwork" "env_subnet" {
  name    = var.app_subnet
  project = var.host_vpc
  region  = var.gcp_region
}

data "google_project" "app_project" {
  project_id = var.app_project_name
}
