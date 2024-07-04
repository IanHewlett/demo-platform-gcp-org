resource "google_compute_subnetwork_iam_binding" "subnet_binding" {
  project    = var.host_vpc
  region     = var.gcp_region
  subnetwork = google_compute_subnetwork.app_subnet.id
  role       = "roles/compute.networkUser"

  members = [
    "serviceAccount:${var.project_number}@cloudservices.gserviceaccount.com",
    "serviceAccount:${var.project_sa_email}",
  ]
}
