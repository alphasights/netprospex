require 'faraday_middleware/response_middleware'

module NetProspex
  module Middleware
    class RaiseExceptions < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          next unless env[:body].is_a?(Hash) && env[:body][:response][:error]
          error = env[:body][:response][:error]
          case error[:code]
          when "ACL"
            raise NetProspex::AccessDenied.new(error[:message])
          when "AUTH"
            raise NetProspex::AuthenticationError.new(error[:message])
          when "DB"
            raise NetProspex::DatabaseError.new(error[:message])
          when "SS"
            raise NetProspex::SearchError.new(error[:message])
          when "PAG"
            raise NetProspex::PaginationError.new(error[:message])
          when "REQ"
            raise NetProspex::ArgumentMissing.new(error[:message])
          when "ZBAL"
            raise NetProspex::ZeroBalanceError.new(error[:message])
          when "FAULT","UNX"
            raise NetProspex::ApiError.new(error[:message])
          else
            raise NetProspex::ApiError.new(error[:message])
          end
        end
      end
    end
  end
end
