locals {
  gcp_region             = "us-central1"
  core_subnet_cidr       = "172.16.34.0/24"
  serverless_subnet_cidr = "10.240.1.0/28"
  jit_services = [
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
