title "Tests for resources created in the core module's implementation of the shared project-core module for the network project."

network_project_name = input("network_project_name")

control "network_project" do
  describe google_project(project: network_project_name) do
    it { should exist }
    its('project_id') { should cmp network_project_name }
    its('lifecycle_state') { should cmp 'ACTIVE' }
  end
end
