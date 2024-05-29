resource "google_service_account" "app_service_account" {
  account_id   = "terraform-sa-${google_project.this.name}"
  display_name = "Terraform-managed."
  description  = "Privileged Terraform service account for app project"
  project      = google_project.this.name
}

resource "google_project_iam_member" "app_project_iam_additive" {
  for_each = var.app_roles

  project = google_project.this.name
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  host_project    = var.host_vpc
  service_project = google_project.this.name
}

resource "google_compute_subnetwork" "app_subnet" {
  name                       = "${var.project_name}-subnet"
  ip_cidr_range              = var.app_subnet_cidr
  network                    = var.host_vpc
  description                = "Terraform-managed."
  purpose                    = "PRIVATE"
  private_ip_google_access   = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  region                     = var.gcp_region
  project                    = var.host_vpc

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

resource "google_compute_subnetwork_iam_binding" "subnet_binding" {
  project    = var.host_vpc
  region     = var.gcp_region
  subnetwork = google_compute_subnetwork.app_subnet.id
  role       = "roles/compute.networkUser"

  members = [
    "serviceAccount:${google_project.this.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:${google_service_account.app_service_account.email}",
  ]
}
