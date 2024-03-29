# frozen_string_literal: true

project_id     = attribute('project_id')
redis_name     = attribute('redis_name')
redis_port     = attribute('redis_port')
redis_zone     = attribute('redis_zone')
redis_firewall = attribute('redis_firewall_name')


control "gcp" do
  title "check gcp instance & firewall"

    describe google_compute_instance(project: project_id,  zone: redis_zone, name: redis_name) do
      it { should exist }
      its('name') { should eq redis_name}
      its('zone') { should match redis_zone }
    end
    describe google_compute_firewall(project: project_id, name: redis_firewall) do
      it { should exist }
      its('name') { should eq redis_firewall }
      it { should allow_port_protocol("#{redis_port}", "tcp") }
    end

end