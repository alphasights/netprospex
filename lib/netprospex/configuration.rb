module NetProspex
  module Configuration
    attr_accessor :consumer_key, :consumer_secret, :scheme
    attr_reader :version

    def version=(v)
      @version = v
    end

    def scheme
      @scheme || 'http'
    end

    def self.extended(base)
      base.reset
    end

    def reset
      self.consumer_key = nil
      self.consumer_secret = nil
      self.version = "1.1"
    end

    def configure
      yield self
    end
  end
end
