require 'spec_helper'
require 'serverspec'

package = 'poudriere'
# service = 'poudriere'
config  = '/usr/local/etc/poudriere.conf'
# user    = 'poudriere'
# group   = 'poudriere'

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }

  its(:content) { should match /NO_ZFS="yes"/ }
  its(:content) { should match Regexp.escape('GIT_URL="https://github.com/reallyenglish/freebsd-ports.git"') }
  its(:content) { should match Regexp.escape('FREEBSD_HOST="ftp://ftp.jp.freebsd.org"') }
end
