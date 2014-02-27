require "spec_helper"
require_relative "../../lib/netprospex.rb"

describe NetProspex::Configuration do
  after(:each) { NetProspex.reset }

  it "can be configured" do
    expect {
      NetProspex.configure do |config|
        config.consumer_key = "foo"
        config.consumer_secret = "bar"
        config.version = "1.1"
      end
    }.to_not raise_exception
  end

  it "stores the api version" do
    NetProspex.configure { |config| config.version = "9.9" }
    NetProspex.version.should == "9.9"
  end
end
