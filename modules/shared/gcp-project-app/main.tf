resource "google_project" "app_project" {
  name                = var.project_name
  project_id          = var.project_name
  folder_id           = var.folder_id
  billing_account     = var.billing_account_id
  skip_delete         = false
  auto_create_network = false
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  project        = google_project.app_project.name
  action         = "DISABLE"
  restore_policy = "REVERT_AND_IGNORE_FAILURE"
}

resource "google_service_account" "app_service_account" {
  account_id   = "terraform-sa-${google_project.app_project.name}"
  display_name = "Terraform-managed."
  description  = "Privileged Terraform service account for app project"
  project      = google_project.app_project.name
}

resource "google_project_service_identity" "servicenetworking" {
  provider = google-beta
  service  = "servicenetworking.googleapis.com"
  project  = google_project.app_project.name
}

resource "google_project_iam_member" "servicenetworking" {
  member  = "serviceAccount:${google_project_service_identity.servicenetworking.email}"
  role    = "roles/servicenetworking.serviceAgent"
  project = google_project.app_project.name
}

resource "google_project_iam_member" "app_project_iam_additive" {
  for_each = var.app_roles

  member  = "serviceAccount:${google_service_account.app_service_account.email}"
  role    = each.key
  project = google_project.app_project.name
}

resource "google_project_service" "project_services" {
  for_each = var.app_services

  service            = each.key
  project            = google_project.app_project.name
  disable_on_destroy = false
}

resource "google_project_service_identity" "cloudbuild_jit_si" {
  provider = google-beta
  service  = "cloudbuild.googleapis.com"
  project  = google_project.app_project.name
}

resource "google_project_service_identity" "pubsub_jit_si" {
  provider = google-beta
  service  = "pubsub.googleapis.com"
  project  = google_project.app_project.name
}

resource "google_project_service_identity" "sqladmin_jit_si" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
  project  = google_project.app_project.name
}

resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  host_project    = var.host_vpc
  service_project = google_project.app_project.name
}

resource "google_compute_subnetwork" "app_subnet" {
  ip_cidr_range              = var.app_subnet_cidr
  name                       = "${var.project_name}-subnet"
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
  subnetwork = google_compute_subnetwork.app_subnet.id
  region     = var.gcp_region
  project    = var.host_vpc
  members = [
    "serviceAccount:${google_project.app_project.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:${google_service_account.app_service_account.email}",
  ]
  role = "roles/compute.networkUser"
}
