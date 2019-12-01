# frozen_string_literal: true

redis_port = attribute('redis_port')
redis_internal_ip = attribute('redis_instance_internal_ip')

control "os" do
  title "check redis instance"

     describe file('/etc/redis.conf') do
       it { should exist }
     end
     describe file('/var/lib/redis') do
      its('type') {should cmp 'directory' }
      its('owner') { should eq 'redis' }
     end
    describe command("redis-cli -h #{redis_internal_ip} -p #{redis_port} ping") do
      its('stdout') { should match (/PONG/) }
    end

end