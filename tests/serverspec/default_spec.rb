require "spec_helper"
require "serverspec"

package = "zabbix54-frontend"
config  = "/usr/local/www/zabbix54/conf/zabbix.conf.php"
ports   = [80, 9000]
user = "www"
group = "www"

case os[:family]
when "openbsd"
  package = "zabbix-web"
  config = "/var/www/zabbix/conf/zabbix.conf.php"
when "ubuntu"
  user = "www-data"
  group = "www-data"
  config = "/usr/share/zabbix/conf/zabbix.conf.php"
  package = "zabbix-frontend-php"
end
describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should exist }
  it { should be_file }
  it { should be_mode 640 }
  it { should be_grouped_into group }
  it { should be_owned_by user }
  its(:content) { should match Regexp.escape("Managed by ansible") }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
