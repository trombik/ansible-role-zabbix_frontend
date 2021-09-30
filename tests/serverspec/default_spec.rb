require "spec_helper"
require "serverspec"

package = "zabbix_frontend"
service = "zabbix_frontend"
config  = "/etc/zabbix_frontend/zabbix_frontend.conf"
user    = "zabbix_frontend"
group   = "zabbix_frontend"
ports   = [PORTS]
log_dir = "/var/log/zabbix_frontend"
db_dir  = "/var/lib/zabbix_frontend"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/zabbix_frontend.conf"
  db_dir = "/var/db/zabbix_frontend"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("zabbix_frontend") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/zabbix_frontend") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
