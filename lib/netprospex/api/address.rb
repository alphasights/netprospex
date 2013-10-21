require 'ostruct'

module NetProspex::Api
  class Address < OpenStruct
    def to_s
      self.formatted_address
    end
  end
end
