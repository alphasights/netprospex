module NetProspex
  module QueryMethods
    class UnexpectedResponseError < StandardError; end

    def find_person(query)
      response = get('/person/profile.json', query)
      store_balance(response)
      if p = fetch_key_from_response_hash(:person_profile, response)[:person]
        return NetProspex::Api::Person.new(p)
      else
        return nil
      end
    end

    def find_person_by_id(id)
      find_person(person_id: id)
    end

    def find_person_by_email(email)
      find_person(email: email)
    end

    def find_people(query)
      # these are boolean but the API wants 0 or 1
      [:calc_found_rows, :preview].each do |k|
        query[k] = 1 if query[k]
      end
      response = get('/person/list.json', query)
      store_balance(response)
      if persons = fetch_key_from_response_hash(:person_list, response)[:persons]
        return persons.map{|p| NetProspex::Api::Person.new(p)}
      else
        return [] #TODO should this raise an error?
      end
    end

    protected

    def store_balance(hash)
      balance = fetch_key_from_response_hash(:transaction, hash)[:account_end_balance]
      @account_balance = balance if balance
    end

    private

    def fetch_key_from_response_hash(key, response_hash)
      response = response_hash.fetch(:response, {})
      raise UnexpectedResponseError, "Unexpected response: #{response}" unless response.respond_to?(:fetch)
      response.fetch(key, {})
    end

  end
end
