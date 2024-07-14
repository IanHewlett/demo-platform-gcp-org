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

module "subnets" {
  source = "./modules/subnets"

  project_name = var.network_project_name
  gcp_region   = var.gcp_region

  network_link           = google_compute_network.vpc.self_link
  core_subnet_cidr       = var.core_subnet_cidr
  serverless_subnet_cidr = var.serverless_subnet_cidr
}

module "routes" {
  source = "./modules/routes"

  project_name = var.network_project_name
  network_link = google_compute_network.vpc.self_link
}

module "firewall" {
  source = "./modules/firewall"

  project_name = var.network_project_name
  network_link = google_compute_network.vpc.self_link
}

module "serviceprojects" {
  source = "./modules/serviceprojects"

  host_vpc                    = google_compute_network.vpc.name
  project_name                = var.network_project_name
  shared_vpc_service_projects = var.shared_vpc_service_projects
}

module "psa" {
  source = "./modules/psa"

  project_name = var.network_project_name
  network_id   = google_compute_network.vpc.id
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
    name = module.subnets.serverless_subnet_name
  }
}
