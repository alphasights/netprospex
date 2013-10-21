require 'ostruct'

module NetProspex::Api
  class Phone < OpenStruct
    def to_s
      self.formatted_number
    end
  end
end
