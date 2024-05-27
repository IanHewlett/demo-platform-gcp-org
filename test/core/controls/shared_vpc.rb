title "Tests for resources created in the core module's implementation of the shared vpc-shared module."

network_project_name = input("network_project_name")

control "shared_vpc" do
  describe google_compute_network(project: network_project_name, name: network_project_name) do
    it { should exist }
  end
end
