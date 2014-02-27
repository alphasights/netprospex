require "spec_helper"
require "vcr_helper"
require_relative "../../lib/netprospex.rb"

describe NetProspex::Client do
  before(:each) do
    NetProspex.configure do |c|
      c.consumer_key = ENV['NETPROSPEX_KEY']
      c.consumer_secret = ENV['NETPROSPEX_SECRET']
    end
  end
  after(:each) { NetProspex.reset }

  let(:client) { NetProspex::Client.new(ENV['NETPROSPEX_USER_TOKEN'], ENV['NETPROSPEX_USER_SECRET']) }

  it "builds the version into the api url" do
    NetProspex.configure { |c| c.version = "9.9" }
    stub = stub_request(:get, %r(api\.netprospex\.com/9\.9/.*)).to_return(body: '{"response":{}}', headers: {'Content-Type' => 'application/json'})
    client.get("/industries.json")
    stub.should have_been_requested
  end

  it "makes GET requests" do
    VCR.use_cassette("industries") do
      client.get("/industries.json")
    end
  end

  it "makes GET requests with fancy parameters" do
    VCR.use_cassette("person-list") do
      client.get("/person/list.json", organization_name: ["Pardot", "Silverpop"])
    end
  end
end
