title "Tests for resources created in the app module's implementation of the shared app-project module."

shared_vpc_project_id = input("host_vpc")
app_project_name = input("app_project_name")
gcp_region = input("gcp_region")
app_subnet_cidr = input("app_subnet_cidr")

control "app_project" do
  describe google_service_account(project: app_project_name, name: "terraform-sa-#{app_project_name}@#{app_project_name}.iam.gserviceaccount.com") do
    it { should exist }
    its('display_name') { should cmp 'Terraform-managed.' }
  end

  describe google_compute_subnetwork(project: shared_vpc_project_id, region: gcp_region, name: "#{app_project_name}-subnet") do
    it { should exist }
    its('ip_cidr_range') { should eq app_subnet_cidr }
    its('log_config.aggregation_interval') { should cmp 'INTERVAL_10_MIN' }
  end
end
