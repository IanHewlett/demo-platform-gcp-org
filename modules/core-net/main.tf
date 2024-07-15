module "shared_vpc" {
  source = "../shared/gcp-vpc-shared"

  network_project_name   = var.network_project_name
  gcp_region             = var.gcp_region
  core_subnet_cidr       = var.core_subnet_cidr
  serverless_subnet_cidr = var.serverless_subnet_cidr

  shared_vpc_service_projects = concat(
    [var.security_project_name],
    var.app_project_names
  )
}

module "vpc_app_project_subnets" {
  for_each = toset(var.app_project_names)
  source   = "../shared/gcp-vpc-service-project"

  project_name    = each.key
  gcp_region      = var.gcp_region
  host_vpc        = module.shared_vpc.host_vpc_name
  app_subnet_cidr = var.app_subnet_cidrs[each.key]
}
