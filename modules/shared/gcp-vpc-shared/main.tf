resource "google_compute_network" "vpc" {
  name                                      = var.network_project_name
  auto_create_subnetworks                   = false
  routing_mode                              = "GLOBAL"
  mtu                                       = 0
  enable_ula_internal_ipv6                  = false
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  project                                   = var.network_project_name
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
  dest_range       = "199.36.153.8/30"
  name             = "${var.network_project_name}-private-googleapis"
  network          = google_compute_network.vpc.self_link
  next_hop_gateway = "default-internet-gateway"
  project          = google_compute_network.vpc.name
}

resource "google_compute_route" "restricted_api_gateway" {
  dest_range       = "199.36.153.4/30"
  name             = "${var.network_project_name}-restricted-googleapis"
  network          = google_compute_network.vpc.self_link
  next_hop_gateway = "default-internet-gateway"
  project          = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "core_subnet" {
  ip_cidr_range              = var.core_subnet_cidr
  name                       = "core-subnet"
  network                    = google_compute_network.vpc.self_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  region                     = var.region
  project                    = google_compute_network.vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_subnetwork" "serverless_subnet" {
  ip_cidr_range              = var.serverless_subnet_cidr
  name                       = "serverless-subnet"
  network                    = google_compute_network.vpc.self_link
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  region                     = var.region
  project                    = google_compute_network.vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_vpc_access_connector" "vpc_connector" {
  name          = "vpcconn-sbx"
  machine_type  = "e2-standard-4"
  min_instances = 2
  max_instances = 3
  region        = var.region
  project       = google_compute_network.vpc.name
  provider      = google-beta

  subnet {
    name = google_compute_subnetwork.serverless_subnet.name
  }
}

resource "google_compute_global_address" "psa_ranges" {
  name          = "cloudsql-psa"
  address       = "10.240.0.0"
  prefix_length = 24
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  network       = google_compute_network.vpc.self_link
  project       = google_compute_network.vpc.name
}

resource "google_service_networking_connection" "psa_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_ranges.name]
}

resource "google_compute_network_peering_routes_config" "psa_routes" {
  peering              = google_service_networking_connection.psa_connection.peering
  export_custom_routes = false
  import_custom_routes = false
  network              = google_compute_network.vpc.name
  project              = google_compute_network.vpc.name
}
