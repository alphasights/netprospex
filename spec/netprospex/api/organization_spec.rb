require 'spec_helper'
require 'vcr_helper'
require_relative '../../../lib/netprospex.rb'

describe NetProspex::Api::Organization do
  before(:each) do
    NetProspex.configure do |c|
      c.consumer_key = ENV['NETPROSPEX_KEY']
      c.consumer_secret = ENV['NETPROSPEX_SECRET']
      c.environment = :sandbox
    end
  end

  let(:client) { NetProspex::Client.new(ENV['NETPROSPEX_USER_TOKEN'], ENV['NETPROSPEX_USER_SECRET']) }
  let(:person) {
    VCR.use_cassette("person-by-id") do
      client.find_person_by_id(29435533)
    end
  }
  let(:organization) { person.organization }

  it "simplifies domains to an array" do
    organization.domains.should be_an Array
    organization.domains.first.should be_a String
  end

  it "converts phones to objects" do
    organization.phones.should be_an Array
    organization.phones.first.should be_a NetProspex::Api::Phone
  end

  it "converts address to an object" do
    organization.postal_address.should be_a NetProspex::Api::Address
  end

  context "when missing data" do
    let(:incomplete_organization) {
      VCR.use_cassette("incomplete-organization") do
        client.find_person_by_id(85652828).organization
      end
    }

    it "has nil address" do
      incomplete_organization.postal_address.should be_nil
    end

    it "has empty phones array" do
      incomplete_organization.phones.should be_an Array
      incomplete_organization.phones.should be_empty
    end
  end
end
