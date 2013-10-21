module NetProspex
  module Configuration
    attr_accessor :consumer_key, :consumer_secret
    attr_reader :environment, :version

    def environment=(env)
      env = env.to_sym
      if [:production, :sandbox].include?(env)
        @environment = env
      else
        raise NetProspex::ConfigurationError.new("Unknown environment #{env}")
      end
    end

    def version=(v)
      @version = v
    end

    def self.extended(base)
      base.reset
    end

    def reset
      self.consumer_key = nil
      self.consumer_secret = nil
      self.environment = :production
      self.version = "1.1"
    end

    def configure
      yield self
    end
  end
end
