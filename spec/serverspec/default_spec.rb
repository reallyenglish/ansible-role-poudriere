require 'spec_helper'
require 'serverspec'

package = 'poudriere'
config  = '/usr/local/etc/poudriere.conf'
basefs = '/usr/local/poudriere'
jail_hook_files = %w[ jail.sh builder.sh ]
describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }

  its(:content) { should match /NO_ZFS="yes"/ }
  its(:content) { should match Regexp.escape('GIT_URL="https://github.com/reallyenglish/freebsd-ports.git"') }
  its(:content) { should match Regexp.escape('FREEBSD_HOST="ftp://ftp.jp.freebsd.org"') }
end

jail_hook_files.each do |f|
  describe file("/usr/local/etc/poudriere.d/hooks/#{f}") do
    its(:content) { should match Regexp.escape('#!/bin/sh') }
    its(:content) { should match Regexp.escape('echo "args=$*"') }
  end
end

describe command('poudriere ports -l') do
  quoted = Regexp.escape("#{basefs}/ports/10_3_re")
  its(:stdout) { should match /^10_3_re\s+git\s+(?:\d+-\d+-\d+\s+\d+:\d+:\d+\s+)?#{quoted}/ }
  its(:stderr) { should match /^$/ }
end

describe command('poudriere ports -l') do
  quoted = Regexp.escape("#{basefs}/ports/freebsd")
  its(:stdout) { should match /^freebsd\s+svn\s+(?:\d+-\d+-\d+\s+\d+:\d+:\d+\s+)?#{quoted}/ }
  its(:stderr) { should match /^$/ }
end

describe command("cd #{basefs}/ports/10_3_re && git config --get remote.origin.url") do
  its(:stdout) { should match Regexp.escape('https://github.com/reallyenglish/freebsd-ports.git') }
  its(:stderr) { should match /^$/ }
end

describe command("cd #{basefs}/ports/10_3_re && git branch") do
  its(:stdout) { should match /10_3_re/ }
  its(:stderr) { should match /^$/ }
end

describe command("cd #{basefs}/ports/freebsd && svnlite info") do
  its(:stdout) { should match Regexp.escape('Repository Root: svn://svn.freebsd.org/ports') }
  its(:stdout) { should match Regexp.escape('URL: svn://svn.freebsd.org/ports/head') }
  its(:stderr) { should match /^$/ }
end

describe command('poudriere jail -l') do
  quoted = Regexp.escape("#{basefs}/jails/10_3")
  its(:stdout) { should match /^10_3\s+10\.3-RELEASE(?:-p\d+)?\s+amd64\s+http\s+(?:\d+-\d+-\d+\s+\d+:\d+:\d+\s+)?#{quoted}/ }
end
