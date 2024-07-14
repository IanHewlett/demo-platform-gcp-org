resource "google_compute_route" "private_api_gateway" {
  project          = var.project_name
  name             = "${var.project_name}-private-googleapis"
  network          = var.network_link
  dest_range       = "199.36.153.8/30"
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_route" "restricted_api_gateway" {
  project          = var.project_name
  name             = "${var.project_name}-restricted-googleapis"
  network          = var.network_link
  dest_range       = "199.36.153.4/30"
  next_hop_gateway = "default-internet-gateway"
}
