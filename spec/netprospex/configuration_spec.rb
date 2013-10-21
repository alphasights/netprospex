require "spec_helper"
require_relative "../../lib/netprospex.rb"

describe NetProspex::Configuration do
  after(:each) { NetProspex.reset }

  it "can be configured" do
    expect {
      NetProspex.configure do |config|
        config.consumer_key = "foo"
        config.consumer_secret = "bar"
        config.environment = :sandbox
        config.version = "1.1"
      end
    }.to_not raise_exception
  end

  it "stores the api version" do
    NetProspex.configure { |config| config.version = "9.9" }
    NetProspex.version.should == "9.9"
  end

  it "validates environment" do
    expect {
      NetProspex.configure do |config|
        config.environment = :bad_value
      end
    }.to raise_exception(NetProspex::ConfigurationError)
  end

  it "accepts environment as a string" do
    NetProspex.configure { |config| config.environment = "sandbox" }
    NetProspex.environment.should == :sandbox
  end
end
