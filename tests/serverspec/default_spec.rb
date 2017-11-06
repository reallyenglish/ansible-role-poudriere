require "spec_helper"
require "serverspec"

package = "poudriere"
config  = "/usr/local/etc/poudriere.conf"
conf_d = "/usr/local/etc/poudriere.d"
basefs = "/usr/local/poudriere"
jail_hook_files = %w(jail.sh builder.sh)
default_owner = "root"
default_group = "wheel"
distfiles = "/usr/ports/distfiles"
key_dir = "/usr/local/etc/poudriere/keys"
key_file = "#{key_dir}/my.key"
ccache_dir = "/var/cache/ccache"

describe package(package) do
  it { should be_installed }
end

describe file(conf_d) do
  it { should be_directory }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 755 }
end

describe file("#{conf_d}/make.conf") do
  it { should exist }
  it { should be_file }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 644 }
  its(:content) { should match(/^LICENSES_ACCEPTED=MSPAT OSI$/) }
  its(:content) { should match(/^MAKE_JOB_NUMBERS=3$/) }
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

describe file(key_dir) do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 755 }
end

describe file(key_file) do
  it { should exist }
  it { should be_file }
  it { should be_owned_by default_owner }
  it { should be_grouped_into default_group }
  it { should be_mode 600 }
  its(:content) { should match(/^-----BEGIN RSA PRIVATE KEY-----$/) }
  its(:content) { should match(/^#{Regexp.escape("MIIEogIBAAKCAQEAwoMg0XK2SdEaz8b8O6rYf+lzDx+ElBXr2ARmFCG+SzKmHf8+")}/) }
end

describe file(ccache_dir) do
  it { should exist }
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
  its(:content) { should match(/^NO_ZFS="yes"$/) }
  its(:content) { should match(/^GIT_URL="#{Regexp.escape("https://github.com/reallyenglish/freebsd-ports-mini.git")}"$/) }
  its(:content) { should match(/^FREEBSD_HOST="#{Regexp.escape("http://ftp.freebsd.org")}"$/) }
  its(:content) { should match(/^PKG_REPO_SIGNING_KEY="#{Regexp.escape("/usr/local/etc/poudriere/keys/my.key")}"$/) }
  its(:content) { should match(/^CCACHE_DIR="#{Regexp.escape(ccache_dir)}"$/) }
end

jail_hook_files.each do |f|
  describe file("/usr/local/etc/poudriere.d/hooks/#{f}") do
    it { should be_file }
    it { should be_owned_by default_owner }
    it { should be_grouped_into default_group }
    it { should be_mode 755 }
    its(:content) { should match(Regexp.escape("#!/bin/sh")) }
    its(:content) { should match(Regexp.escape('echo "args=$*"')) }
  end
end

describe command("poudriere ports -l") do
  quoted = Regexp.escape("#{basefs}/ports/mini")
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^mini\s+git\s+(?:\d+-\d+-\d+\s+\d+:\d+:\d+\s+)?#{quoted}/) }
  its(:stdout) { should match(/^vagrant\s+-\s+#{Regexp.escape("/home/vagrant/freebsd-ports")}$/) }
  its(:stderr) { should match(/^$/) }
end

describe command("cd #{basefs}/ports/mini && git config --get remote.origin.url") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.escape("https://github.com/reallyenglish/freebsd-ports-mini.git")) }
  its(:stderr) { should match(/^$/) }
end

describe command("cd #{basefs}/ports/mini && git branch") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/20170222/) }
  its(:stderr) { should match(/^$/) }
end

describe command("poudriere jail -l") do
  quoted = Regexp.escape("#{basefs}/jails/10_3")
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^10_3\s+10\.3-RELEASE(?:-p\d+)?\s+amd64\s+http\s+(?:\d+-\d+-\d+\s+\d+:\d+:\d+\s+)?#{quoted}/) }
  its(:stderr) { should match(/^$/) }
end
