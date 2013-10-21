require 'faraday_middleware/response_middleware'
module NetProspex
  module Middleware
    class Rubyize < FaradayMiddleware::ResponseMiddleware
      extend NetProspex::Helpers::Formatters

      define_parser do |body|
        rubyize_keys(body) if body.is_a? Hash
      end

      def parse_response?(env)
        env[:body].is_a? Hash
      end
    end
  end
end
