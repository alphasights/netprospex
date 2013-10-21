module NetProspex::Api
  module HasPhones
    def initialize(*args)
      super(*args)
      self.phones ||= []
      self.phones.map! do |phone|
        if phone.is_a? Hash
          if phone[:national_number] && !phone[:national_number].empty?
            NetProspex::Api::Phone.new(phone)
          else
            nil
          end
        else
          phone
        end
      end
      self.phones.compact!
    end
  end
  module HasAddress
    def initialize(*args)
      super(*args)
      if self.postal_address.is_a? Hash
        formatted_address = self.postal_address[:formatted_address]
        if formatted_address && !formatted_address.empty?
          self.postal_address = NetProspex::Api::Address.new(self.postal_address)
        else
          self.postal_address = nil
        end
      end
    end
  end
  module HasOrganization
    def initialize(*args)
      super(*args)
      if self.organization.is_a? Hash
        self.organization = NetProspex::Api::Organization.new(self.organization)
      end
    end
  end
  module HasDomains
    def initialize(*args)
      super(*args)
      if self.domains.is_a? Hash
        domain = self.domains.fetch(:domain, {})[:url]
        self.domains = domain ? [domain] : []
      elsif self.domains.is_a? Array #TODO: I'm just guessing at this formatting
        self.domains.map! {|h| h[:domain][:url]}
      end
    end
  end
end
