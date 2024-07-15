## Create an IP address
# Represents a Global Address resource. Global addresses are used for HTTP(S) load balancing.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "static_ip_address" {
  name    = "static-ip-address"
  project = var.project_name
}
