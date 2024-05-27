title "Tests for resources created in the global module's implementation of the shared project-core module for the cicd project."

cicd_project_name = input("cicd_project_name")

control "cicd_project_name" do
  describe google_project(project: cicd_project_name) do
    it { should exist }
    its('project_id') { should cmp cicd_project_name}
    its('lifecycle_state') { should cmp 'ACTIVE' }
  end
end
