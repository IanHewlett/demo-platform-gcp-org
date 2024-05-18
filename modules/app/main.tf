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
