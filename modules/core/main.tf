module "monitoring_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.core_folder_id
  project_name       = var.monitoring_project_name
  enable_iap         = false

  project_services = [
    "admin.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "groupssettings.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "networkmanagement.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
  ]

  jit_services = []
  bindings     = {}
}

module "security_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.core_folder_id
  project_name       = var.security_project_name
  enable_iap         = false

  project_services = [
    "admin.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "groupssettings.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "networkmanagement.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
  ]

  jit_services = [
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com"
  ]

  bindings = {}
}

module "network_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.core_folder_id
  project_name       = var.network_project_name
  enable_iap         = false

  project_services = [
    "admin.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "groupssettings.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "networkmanagement.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
  ]

  jit_services = [
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com"
  ]

  bindings = {
    "roles/compute.networkAdmin" = [
      var.groups["admins"]
    ]
    "roles/compute.securityAdmin" = [
      var.groups["admins"],
      "serviceAccount:${var.core_cicd_sa_email}"
    ]
    "roles/compute.networkViewer" = values(module.app_cicd_service_account)[*].sa_member
    "roles/vpcaccess.admin" = [
      "serviceAccount:${var.core_cicd_sa_email}"
    ]
    "roles/vpcaccess.user" = [
      for number in values(module.app_projects)[*].number : "serviceAccount:service-${number}@serverless-robot-prod.iam.gserviceaccount.com"
    ]
  }
}

module "app_folder" {
  source = "../shared/gcp-folder"

  folder_name      = "app"
  parent_folder_id = var.core_folder_id

  bindings = {
    "roles/storage.admin" = values(module.app_cicd_service_account)[*].sa_member
    "roles/logging.admin" = concat(
      ["serviceAccount:${var.core_cicd_sa_email}"],
      values(module.app_cicd_service_account)[*].sa_member
    )
    "roles/iap.admin" = [
      var.groups["admins"]
    ]
    "roles/oauthconfig.editor" = [
      var.groups["admins"]
    ]
    "roles/compute.viewer" = [
      var.groups["developers"]
    ]
    "roles/storage.objectCreator" = [
      var.groups["developers"]
    ]
    "roles/storage.objectViewer" = [
      var.groups["developers"]
    ]
  }
}

module "app_projects" {
  for_each = var.app_project_names
  source   = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = module.app_folder.folder_id
  project_name       = each.key
  enable_iap         = true

  project_services = [
    "admin.googleapis.com",
    "apigateway.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
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
    "workflowexecutions.googleapis.com",
  ]

  jit_services = [
    "cloudbuild.googleapis.com",
    "eventarc.googleapis.com",
    "pubsub.googleapis.com",
    "sqladmin.googleapis.com"
  ]

  bindings = {}
}

#TODO this role is not able to be used on the folder
resource "google_project_iam_member" "sa_core_cicd_iam_role_admin" {
  for_each = module.app_projects

  project = each.value.name
  role    = "roles/iam.roleAdmin"
  member  = "serviceAccount:${var.core_cicd_sa_email}"
}
