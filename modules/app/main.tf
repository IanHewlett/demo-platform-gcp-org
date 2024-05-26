module "app_project" {
  source = "../shared/gcp-project-app"

  project_name       = var.app_project_name
  app_roles          = var.app_roles
  app_services       = var.app_services
  billing_account_id = var.billing_account_id
  folder_id          = var.app_folder_id
  host_vpc           = var.host_vpc
  region             = var.region
  app_subnet         = var.app_subnet
}

module "cloud_run_ui_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = module.app_project.name
  region                 = var.region
  cloud_run_service_name = "app-ui-service"

  service_account_roles = []
}

module "cloud_run_api_service" {
  source = "../shared/gcp-cloud-run"

  project_name           = module.app_project.name
  region                 = var.region
  cloud_run_service_name = "app-api-service"

  service_account_roles = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent"
  ]
}
