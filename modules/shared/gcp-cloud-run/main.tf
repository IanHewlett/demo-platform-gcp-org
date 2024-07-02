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
