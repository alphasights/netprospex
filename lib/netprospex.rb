Dir[File.dirname(__FILE__) + '/netprospex/helpers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/netprospex/middleware/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/netprospex/api/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/netprospex/*.rb'].each {|file| require file }

module NetProspex
  extend Configuration
end
