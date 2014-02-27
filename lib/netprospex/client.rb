require "netprospex/query_methods"
require "faraday"
require "faraday_middleware"

module NetProspex
  class Client
    include NetProspex::Helpers::Formatters
    include NetProspex::QueryMethods
    attr_reader :account_balance

    def initialize(token, secret)
      @token = token
      @secret = secret
    end

    def get(path, query={})
      http.get(api_url(path, query)).body
    end

    def post(path, params={})
      http.post(api_url(path), params).body
    end

    protected

    def api_base
      @api_base = "#{NetProspex.scheme}://api.netprospex.com/#{NetProspex.version}"
    end

    def api_url(path, query={})
      api_base + path + stringify_query(query)
    end

    def http
      raise NetProspex::ConfigurationError if api_base.nil?

      @http ||=  Faraday.new do |builder|
        builder.use Faraday::Request::OAuth, {
          consumer_key: NetProspex.consumer_key,
          consumer_secret: NetProspex.consumer_secret,
          token: @token,
          token_secret: @secret
        }

        builder.use NetProspex::Middleware::RaiseExceptions
        builder.use NetProspex::Middleware::Rubyize, content_type: /\bjson$/
        builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/

        builder.adapter :net_http
      end
    end
  end
end
