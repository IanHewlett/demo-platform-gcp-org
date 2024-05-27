title "Tests for resources created in the app module's implementation of the shared notification module."

app_project_name = input("app_project_name")

control "notifications" do
  describe google_project_alert_policies(project: app_project_name) do
    it { should exist }
    its('policy_display_names') { should include 'CloudSQL Instance - High CPU Utilization'}
    its('policy_display_names') { should include 'CloudSQL Database - PostgreSQL Connections'}
  end
end
