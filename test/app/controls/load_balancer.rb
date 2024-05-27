title "Tests for resources created in the app module's implementation of the shared load-balancer module."

app_project_name = input("app_project_name")

control "load_balancer" do
  describe google_compute_ssl_certificate(project: app_project_name, name: 'managed-cert') do
    it { should exist }
  end
end
