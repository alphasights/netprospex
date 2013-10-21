require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "fixtures/cassettes"
  c.hook_into :webmock
  c.default_cassette_options  = { :record => :once }
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<NETPROSPEX_KEY>') { ENV['NETPROSPEX_KEY'] }
  c.filter_sensitive_data('<NETPROSPEX_SECRET>') { ENV['NETPROSPEX_SECRET'] }
  c.filter_sensitive_data('<NETPROSPEX_USER_TOKEN>') { ENV['NETPROSPEX_USER_TOKEN'] }
  c.filter_sensitive_data('<NETPROSPEX_USER_SECRET>') { ENV['NETPROSPEX_USER_SECRET'] }
end
