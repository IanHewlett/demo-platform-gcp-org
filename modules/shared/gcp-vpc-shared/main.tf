resource "google_compute_network" "vpc" {
  project                                   = var.network_project_name
  name                                      = var.network_project_name
  auto_create_subnetworks                   = false
  routing_mode                              = "GLOBAL"
  mtu                                       = 0
  enable_ula_internal_ipv6                  = false
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  project = google_compute_network.vpc.name
}

resource "google_compute_shared_vpc_service_project" "sec_service_project" {
  host_project    = google_compute_shared_vpc_host_project.shared_vpc_host.id
  service_project = var.security_project_name
}

resource "google_compute_route" "private_api_gateway" {
  project          = google_compute_network.vpc.name
  name             = "${var.network_project_name}-private-googleapis"
  network          = google_compute_network.vpc.self_link
  dest_range       = "199.36.153.8/30"
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_route" "restricted_api_gateway" {
  project          = google_compute_network.vpc.name
  name             = "${var.network_project_name}-restricted-googleapis"
  network          = google_compute_network.vpc.self_link
  dest_range       = "199.36.153.4/30"
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_subnetwork" "core_subnet" {
  project                    = google_compute_network.vpc.name
  name                       = "core-subnet"
  ip_cidr_range              = var.core_subnet_cidr
  region                     = var.gcp_region
  network                    = google_compute_network.vpc.self_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_subnetwork" "serverless_subnet" {
  project                    = google_compute_network.vpc.name
  name                       = "serverless-subnet"
  ip_cidr_range              = var.serverless_subnet_cidr
  region                     = var.gcp_region
  network                    = google_compute_network.vpc.self_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_vpc_access_connector" "vpc_connector" {
  provider = google-beta

  project       = google_compute_network.vpc.name
  name          = "vpcconn-sbx"
  region        = var.gcp_region
  machine_type  = "e2-standard-4"
  min_instances = 2
  max_instances = 3

  subnet {
    name = google_compute_subnetwork.serverless_subnet.name
  }
}

resource "google_compute_global_address" "psa_ranges" {
  project       = google_compute_network.vpc.name
  name          = "cloudsql-psa"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  address       = "10.240.0.0"
  prefix_length = 24
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "psa_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_ranges.name]
}

resource "google_compute_network_peering_routes_config" "psa_routes" {
  project              = google_compute_network.vpc.name
  peering              = google_service_networking_connection.psa_connection.peering
  network              = google_compute_network.vpc.name
  export_custom_routes = false
  import_custom_routes = false
}
