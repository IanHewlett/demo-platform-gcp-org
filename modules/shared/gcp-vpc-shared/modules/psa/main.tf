## Create an IP address
# Represents a Global Address resource. Global addresses are used for HTTP(S) load balancing.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "psa_ranges" {
  project       = var.project_name
  name          = "cloudsql-psa"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  address       = "10.240.0.0"
  prefix_length = 24
  network       = var.network_id
}

## Create a private connection
# Manages a private VPC connection with a GCP service provider.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
resource "google_service_networking_connection" "psa_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_ranges.name]
}

## (Optional) Import or export custom routes
# Manage a network peering's route settings without managing the peering as a whole.
# This resource is primarily intended for use with GCP-generated peerings that shouldn't otherwise be managed by other tools.
# Deleting this resource is a no-op and the peering will not be modified.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering_routes_config
resource "google_compute_network_peering_routes_config" "psa_routes" {
  project              = var.project_name
  peering              = google_service_networking_connection.psa_connection.peering
  network              = var.project_name
  export_custom_routes = false
  import_custom_routes = false
}
