module "global_folder" {
  source = "../shared/gcp-folder"

  folder_name      = var.global_folder_name
  parent_folder_id = var.root_folder_num

  bindings = {
    "roles/billing.projectManager" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.projectCreator" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.folderAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/storage.admin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/compute.xpnAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.folderAdmin" = [
      var.groups["admins"]
    ]
    "roles/iam.serviceAccountUser" = [
      var.groups["admins"]
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      var.groups["admins"]
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      var.groups["admins"]
    ]
    "roles/viewer" = [
      var.groups["viewers"],
      var.groups["developers"],
      var.groups["admins"]
    ]
  }
}

module "cicd_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = module.global_folder.folder_id
  project_name       = var.cicd_project_name

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

module "cloud_build" {
  source = "../shared/gcp-cloud-build"

  cicd_project_name = module.cicd_project.name
}

#TODO should this be in core tier? else need handling here for nonprod and prod as well
module "core_folder" {
  source = "../shared/gcp-folder"

  folder_name      = "sandbox"
  parent_folder_id = module.global_folder.folder_id

  bindings = {
    "roles/storage.objectAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/storage.admin" = [
      "serviceAccount:${module.core_cicd_service_account.email}",
      "serviceAccount:${module.cicd_project.number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudbuild.builds.editor" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/cloudbuild.builds.builder" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/logging.logWriter" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/logging.admin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
  }
}
