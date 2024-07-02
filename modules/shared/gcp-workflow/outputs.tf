output "file_processing_workflow" {
  value = google_workflows_workflow.file_processing_workflow
}

output "sa_member" {
  value = "serviceAccount:${module.workflow_service_account.email}"
}
