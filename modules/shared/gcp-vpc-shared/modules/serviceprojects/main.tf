resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  for_each = var.shared_vpc_service_projects

  host_project    = var.host_vpc
  service_project = each.key
}
