locals {
  app_subnet_cidr = "172.16.32.0/24"
  app_roles = [
    "roles/cloudscheduler.admin",
    "roles/cloudsql.admin",
    "roles/compute.instanceAdmin",
    "roles/compute.loadBalancerAdmin",
    "roles/compute.networkAdmin",
    "roles/eventarc.admin",
    "roles/iam.roleAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/monitoring.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/run.admin",
    "roles/secretmanager.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.hmacKeyAdmin",
    "roles/workflows.admin"
  ]
  app_services = [
    "admin.googleapis.com",
    "apigateway.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudshell.googleapis.com",
    "compute.googleapis.com",
    "eventarc.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com",
    "orgpolicy.googleapis.com",
    "osconfig.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
    "workflows.googleapis.com",
  ]
  jit_services = [
    "cloudbuild.googleapis.com",
    "pubsub.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}
