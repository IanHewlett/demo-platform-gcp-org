title "Tests for resources created in the app module's implementation of the shared cloud-run module for the api service."

app_project_name = input("app_project_name")

control "cloud_run_api_service" do
  describe google_service_account(project: app_project_name, name: "app-api-service-runner@#{app_project_name}.iam.gserviceaccount.com") do
    it { should exist }
    its('display_name') { should cmp 'Runtime service account for app-api-service' }
  end
end
