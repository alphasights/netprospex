require 'spec_helper'
require 'vcr_helper'
require_relative "../../../lib/netprospex.rb"

describe NetProspex::Middleware::RaiseExceptions do
  before(:each) do
    NetProspex.configure do |c|
      c.consumer_key = ENV['NETPROSPEX_KEY']
      c.consumer_secret = ENV['NETPROSPEX_SECRET']
      c.environment = :sandbox
    end
  end

  let(:client) { NetProspex::Client.new(ENV['NETPROSPEX_USER_TOKEN'], ENV['NETPROSPEX_USER_SECRET']) }

  it "raises AccessDenied" do
    VCR.use_cassette('acl-error') do
      expect {
        client.get('/prospect/profile.json', organization_name: 'Pardot')
      }.to raise_exception(NetProspex::AccessDenied)
    end
  end

  it "raises AuthenticationError" do
    VCR.use_cassette('auth-error') do
      expect {
        NetProspex::Client.new('bad','keys').get('/industries.json')
      }.to raise_exception(NetProspex::AuthenticationError)
    end
  end

  it "raises PaginationError" do
    VCR.use_cassette('pag-error') do
      expect {
        client.get('/person/list.json', organization_name: 'Pardot', offset: -1)
      }.to raise_exception(NetProspex::PaginationError)
    end
  end

  it "raises ArgumentMissing" do
    VCR.use_cassette('req-error') do
      expect {
        client.get('/person/list.json')
      }.to raise_exception(NetProspex::ArgumentMissing)
    end
  end

  # these are hard to produce so they're stubbed instead of VCRed
  it "raises ZeroBalanceError" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(body: '{"response":{"error":{"message":"zero balance","code":"ZBAL"}}}', headers: {'Content-Type' => 'application/json'})
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::ZeroBalanceError)
  end

  it "raises DatabaseError" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(body: '{"response":{"error":{"message":"database error","code":"DB"}}}', headers: {'Content-Type' => 'application/json'})
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::DatabaseError)
  end

  it "raises SearchError" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(body: '{"response":{"error":{"message":"search engine error","code":"SS"}}}', headers: {'Content-Type' => 'application/json'})
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::SearchError)
  end

  it "raises ApiError for unknown error" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(body: '{"response":{"error":{"message":"unknown error","code":"UNX"}}}', headers: {'Content-Type' => 'application/json'})
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::ApiError)
  end

  it "raises ApiError for general error" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(body: '{"response":{"error":{"message":"general error","code":"FAULT"}}}', headers: {'Content-Type' => 'application/json'})
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::ApiError)
  end

  it "raises ApiError for version error" do
    stub_request(:get, %r(api-sb\.netprospex\.com/1\.1/person/list\.json)).to_return(
      body: '{"response":{"version":"1.1","responseId":"8A3837BF-AB10-F3B4-EA19-0606207939CE","responseType":"error","request":{"startTime":"2013-09-04 09:18:21","requestType":"person_list","url":"\/1.1\/person\/list.json?firstName=Bob&lastName=Colananni&preview=1","userId":"1aebe6ed-6c79-11e2-a4df-f04da23ce7b0"},"transaction":{"accountId":"1ad39da8-6c79-11e2-a4df-f04da23ce7b0","accountStartBalance":100000,"accountEndBalance":null},"error":{"message":"invalid API version=1.1","code":"ARG"},"debug":{"requestTime":0.0185089111328}}}',
      headers: {'Content-Type' => 'application/json'}
    )
    expect {
      puts client.get('/person/list.json', organization_name: 'Pardot')
    }.to raise_exception(NetProspex::ApiError)
  end
end
