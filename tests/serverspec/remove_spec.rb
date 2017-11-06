require "spec_helper"
require "serverspec"

package = "poudriere"
config  = "/usr/local/etc/poudriere.conf"
basefs = "/usr/local/poudriere"
conf_d = "/usr/local/etc/poudriere.d"
default_owner = "root"
default_group = "wheel"
distfiles = "/usr/ports/distfiles"

describe package(package) do
  it { should be_installed }
end

describe file(basefs) do
  it { should be_directory }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 755 }
end

describe file(distfiles) do
  it { should be_directory }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 755 }
end

describe file(config) do
  it { should be_file }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 644 }
  its(:content) { should match(/NO_ZFS="yes"/) }
  its(:content) { should match(Regexp.escape('GIT_URL="https://github.com/reallyenglish/freebsd-ports-mini.git"')) }
  its(:content) { should match(Regexp.escape('FREEBSD_HOST="http://ftp.freebsd.org"')) }
end

describe command("poudriere ports -l") do
  its(:exit_status) { should eq 70 }
  its(:stdout) { should_not match(/^mini\s/) }
  its(:stderr) { should eq "" }
end

describe command("poudriere jails -l") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/10_3\s/) }
  its(:stderr) { should eq "" }
end

describe file("#{basefs}/ports/mini") do
  it { should_not exist }
end

describe file("#{conf_d}/make.conf") do
  it { should_not exist }
end
