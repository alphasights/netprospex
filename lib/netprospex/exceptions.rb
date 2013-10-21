module NetProspex
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class ApiError < Error; end
  class AccessDenied < ApiError; end
  class AuthenticationError < ApiError; end
  class DatabaseError < ApiError; end
  class SearchError < ApiError; end
  class PaginationError < ApiError; end
  class ArgumentMissing < ApiError; end
  class ZeroBalanceError < ApiError; end
end
