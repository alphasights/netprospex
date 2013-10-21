module NetProspex
  module QueryMethods
    def find_person(query)
      response = get('/person/profile.json', query)
      store_balance(response)
      if p = response.fetch(:response,{}).fetch(:person_profile,{})[:person]
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
      if persons = response.fetch(:response,{}).fetch(:person_list,{})[:persons]
        return persons.map{|p| NetProspex::Api::Person.new(p)}
      else
        return [] #TODO should this raise an error?
      end
    end

    protected
    def store_balance(hash)
      balance = hash.fetch(:response,{}).fetch(:transaction,{})[:account_end_balance]
      @account_balance = balance if balance
    end
  end
end
