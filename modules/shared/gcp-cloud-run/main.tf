resource "google_cloud_run_v2_service" "service" {
  name     = var.cloud_run_service_name
  location = var.gcp_region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project  = var.project_name

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}

resource "google_service_account" "service_runner" {
  account_id   = "${var.cloud_run_service_name}-runner"
  display_name = "Runtime service account for ${var.cloud_run_service_name}"
  project      = var.project_name
}

resource "google_project_iam_member" "service_runner_roles" {
  for_each = toset(var.service_account_roles)

  member  = "serviceAccount:${google_service_account.service_runner.email}"
  role    = each.value
  project = var.project_name
}
