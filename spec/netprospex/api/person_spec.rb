require 'spec_helper'
require 'vcr_helper'
require_relative '../../../lib/netprospex.rb'

describe NetProspex::Api::Person do
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

  it "converts organization to an object" do
    person.organization.should be_a NetProspex::Api::Organization
  end

  it "converts phones to objects" do
    person.phones.should be_an Array
    person.phones.first.should be_a NetProspex::Api::Phone
  end

  it "converts address to an object" do
    person.postal_address.should be_a NetProspex::Api::Address
  end

  context "when missing data" do
    let(:incomplete_person) {
      VCR.use_cassette("incomplete-person") do
        client.find_people(organization_name: "Pardot", preview: true, limit: 1).first
      end
    }

    it "has empty phones array" do
      incomplete_person.phones.should be_an Array
      incomplete_person.phones.should be_empty
    end
  end
end
