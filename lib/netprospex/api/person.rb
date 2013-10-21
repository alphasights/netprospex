require 'netprospex/api/sub_objects.rb'
require 'ostruct'

module NetProspex::Api
  class Person < OpenStruct
    include HasAddress
    include HasPhones
    include HasOrganization
  end
end
