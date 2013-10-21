require 'netprospex/api/sub_objects.rb'
require 'ostruct'

module NetProspex::Api
  class Organization < OpenStruct
    include HasAddress
    include HasPhones
    include HasDomains
  end
end
