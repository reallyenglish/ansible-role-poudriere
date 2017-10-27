require "infrataster/rspec"

ENV["VAGRANT_CWD"] = File.dirname(__FILE__)
ENV["LANG"] = "C"

Infrataster::Server.define(
  :server1,
  "192.168.21.100",
  vagrant: true
)
Infrataster::Server.define(
  :server2,
  "192.168.21.101",
  vagrant: true
)

def json_body_as_hash
  json_str_to_hash(response.body)
end

def json_str_to_hash(str)
  JSON.parse(str)
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = "default"
end
