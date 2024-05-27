title "Tests for resources created in the app module's implementation of the shared cloudsql module."

environment = input("environment")
app_project_name = input("app_project_name")

control "cloudsql_api" do
  describe google_sql_database(project: app_project_name, instance: "api-#{environment}", name: "api-#{environment}-db") do
    it { should exist }
    its('name') { should eq "api-#{environment}-db" }
    its('instance') { should eq "api-#{environment}" }
  end

  describe google_sql_database_instance(project: app_project_name, instance: "api-#{environment}") do
    it { should exist }
    its('state') { should eq 'RUNNABLE' }
    its('backend_type') { should eq 'SECOND_GEN' }
    its('database_version') { should eq 'POSTGRES_15' }
  end
end
