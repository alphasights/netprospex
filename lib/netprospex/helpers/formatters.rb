require "active_support/all"
require "uri"

module NetProspex
  module Helpers
    module Formatters
      def stringify_query(query)
        return "" if query.blank?
        components = []
        unrubyize_keys(query).each do |k,v|
          if v.is_a? Array
            v.each do |w|
              components << [k+'[]', w]
            end
          else
            components << [k,v]
          end
        end
        "?" + URI.encode_www_form(components)
      end

      def unrubyize_keys(hash)
        new_hash = {}
        hash.each do |k,v|
          new_k = case k
                  when Symbol
                    k.to_s.camelize(:lower)
                  else
                    k
                  end
          new_v = case v
                  when Hash
                    unrubyize_keys(v)
                  when Array
                    v.map {|w| (Hash === w) ? unrubyize_keys(w) : w}
                  else
                    v
                  end
          new_hash[new_k] = new_v
        end
        new_hash
      end

      def rubyize_keys(hash)
        new_hash = {}
        hash.each do |k,v|
          new_k = case k
                  when String
                    k.underscore.to_sym
                  else
                    k
                  end
          new_v = case v
                  when Hash
                    rubyize_keys(v)
                  when Array
                    v.map {|w| (Hash === w) ? rubyize_keys(w) : w}
                  else
                    v
                  end
          new_hash[new_k] = new_v
        end
        new_hash
      end
    end
  end
end
