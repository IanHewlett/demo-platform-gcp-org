title "Tests for resources created in the core module's implementation of the shared project-core module for the security project."

security_project_name = input("security_project_name")

control "security_project" do
  describe google_project(project: security_project_name) do
    it { should exist }
    its('project_id') { should cmp security_project_name}
    its('lifecycle_state') { should cmp 'ACTIVE' }
  end
end
