resource "google_folder" "core" {
  display_name = var.environment
  parent       = var.project_folder_id
}

resource "google_folder" "app" {
  display_name = "app"
  parent       = google_folder.core.id
}

module "network_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = google_folder.core.id
  project_name       = var.network_project_name
  project_services   = var.project_services
  jit_services       = var.jit_services
}

module "security_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = google_folder.core.id
  project_name       = var.security_project_name
  project_services   = var.project_services
  jit_services       = var.jit_services
}

module "shared_vpc" {
  source = "../shared/gcp-vpc-shared"

  network_project_name   = module.network_project.name
  security_project_name  = module.security_project.name
  gcp_region             = var.gcp_region
  core_subnet_cidr       = var.core_subnet_cidr
  serverless_subnet_cidr = var.serverless_subnet_cidr
}
