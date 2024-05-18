resource "google_project" "app_project" {
  auto_create_network = false
  billing_account     = var.billing_account_id
  folder_id           = var.folder_id
  name                = var.project_name
  project_id          = var.project_name
  skip_delete         = false
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  action         = "DISABLE"
  project        = google_project.app_project.name
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
  project  = google_project.app_project.name
  service  = "servicenetworking.googleapis.com"
}

resource "google_project_iam_member" "servicenetworking" {
  member  = "serviceAccount:${google_project_service_identity.servicenetworking.email}"
  project = google_project.app_project.name
  role    = "roles/servicenetworking.serviceAgent"
}

resource "google_project_iam_member" "app_project_iam_additive" {
  for_each = var.app_roles

  project = google_project.app_project.name
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

resource "google_project_service" "project_services" {
  for_each = var.app_services

  disable_dependent_services = false
  disable_on_destroy         = false
  project                    = google_project.app_project.name
  service                    = each.key
}

resource "google_project_service_identity" "cloudbuild_jit_si" {
  provider = google-beta
  project  = google_project.app_project.name
  service  = "cloudbuild.googleapis.com"
}

resource "google_project_service_identity" "pubsub_jit_si" {
  provider = google-beta
  project  = google_project.app_project.name
  service  = "pubsub.googleapis.com"
}

resource "google_project_service_identity" "sqladmin_jit_si" {
  provider = google-beta
  project  = google_project.app_project.name
  service  = "sqladmin.googleapis.com"
}

resource "google_compute_shared_vpc_service_project" "vpc_service_project" {
  host_project    = var.host_vpc
  service_project = google_project.app_project.name
}

resource "google_compute_subnetwork" "app_subnet" {
  project       = var.host_vpc
  network       = var.host_vpc
  name          = "${var.project_name}-subnet"
  region        = var.region
  ip_cidr_range = var.app_subnet
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
  }
}

resource "google_compute_subnetwork_iam_binding" "subnet_binding" {
  members = [
    "serviceAccount:${google_project.app_project.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:${google_service_account.app_service_account.email}",
  ]
  project    = var.host_vpc
  region     = var.region
  role       = "roles/compute.networkUser"
  subnetwork = google_compute_subnetwork.app_subnet.id
}
