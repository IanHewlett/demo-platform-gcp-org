output "sa_member" {
  value = "serviceAccount:${module.bastion_host_service_account.email}"
}
