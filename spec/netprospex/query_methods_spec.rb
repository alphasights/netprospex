require 'spec_helper'
require 'vcr_helper'
require_relative "../../lib/netprospex.rb"

describe NetProspex::QueryMethods do
  before(:each) do
    NetProspex.configure do |c|
      c.consumer_key = ENV['NETPROSPEX_KEY']
      c.consumer_secret = ENV['NETPROSPEX_SECRET']
      c.environment = :sandbox
    end
  end

  let(:client) { NetProspex::Client.new(ENV['NETPROSPEX_USER_TOKEN'], ENV['NETPROSPEX_USER_SECRET']) }

  describe "#find_person_by_id" do
    it "gets a person" do
      VCR.use_cassette("person-by-id") do
        resp = client.find_person_by_id(29435533)
        resp.should be_a NetProspex::Api::Person
        resp.person_id.should == 29435533
      end
    end

    it "stores account balance" do
      VCR.use_cassette("person-by-id") do
        client.account_balance.should be_nil
        client.find_person_by_id(29435533)
        client.account_balance.should_not be_nil
      end
    end
  end

  describe "#find_person_by_email" do
    it "gets a person" do
      VCR.use_cassette("person-by-email") do
        resp = client.find_person_by_email("grublev@netprospex.com")
        resp.should be_a NetProspex::Api::Person
        resp.email.should == "grublev@netprospex.com"
      end
    end

    it "stores account balance" do
      VCR.use_cassette("person-by-email") do
        client.account_balance.should be_nil
        client.find_person_by_email("grublev@netprospex.com")
        client.account_balance.should_not be_nil
      end
    end
  end

  describe "#find_people" do
    it "gets a list of people" do
      VCR.use_cassette("person-list") do
        resp = client.find_people(organization_name: ["Pardot", "Silverpop"])
        resp.should be_an Array
        resp.first.should be_a NetProspex::Api::Person
      end
    end

    it "stores account balance" do
      VCR.use_cassette("person-list") do
        client.account_balance.should be_nil
        client.find_people(organization_name: ["Pardot", "Silverpop"])
        client.account_balance.should_not be_nil
      end
    end
  end
end
