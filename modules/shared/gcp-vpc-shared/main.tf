resource "google_compute_network" "vpc" {
  auto_create_subnetworks                   = false
  delete_default_routes_on_create           = false
  description                               = "Terraform-managed."
  enable_ula_internal_ipv6                  = false
  mtu                                       = 0
  name                                      = var.network_project_name
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  project                                   = var.network_project_name
  routing_mode                              = "GLOBAL"
}

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project = google_compute_network.vpc.name
}

resource "google_compute_shared_vpc_service_project" "sec_service_project" {
  host_project    = google_compute_shared_vpc_host_project.shared_vpc_host.id
  service_project = var.security_project_name
}

resource "google_compute_route" "private_api_gateway" {
  description      = "Terraform-managed."
  dest_range       = "199.36.153.8/30"
  name             = "${var.network_project_name}-private-googleapis"
  network          = google_compute_network.vpc.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  project          = google_compute_network.vpc.name
}

resource "google_compute_route" "restricted_api_gateway" {
  description      = "Terraform-managed."
  dest_range       = "199.36.153.4/30"
  name             = "${var.network_project_name}-restricted-googleapis"
  network          = google_compute_network.vpc.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  project          = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "core_subnet" {
  project       = google_compute_network.vpc.name
  network       = google_compute_network.vpc.self_link
  name          = "core-subnet"
  region        = var.region
  ip_cidr_range = var.core_subnet_cidr
  description   = "Terraform-managed."

  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    filter_expr          = "true"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "serverless_subnet" {
  project       = google_compute_network.vpc.name
  network       = google_compute_network.vpc.self_link
  name          = "serverless-subnet"
  region        = var.region
  ip_cidr_range = var.serverless_subnet_cidr
  description   = "Terraform-managed."

  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    filter_expr          = "true"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    metadata_fields      = []
  }
}

resource "google_vpc_access_connector" "vpc_connector" {
  project        = google_compute_network.vpc.name
  name           = "vpcconn-sbx"
  provider       = google-beta
  region         = var.region
  min_instances  = 2
  max_instances  = 3
  machine_type   = "e2-standard-4"
  subnet {
    name = google_compute_subnetwork.serverless_subnet.name
  }
}
