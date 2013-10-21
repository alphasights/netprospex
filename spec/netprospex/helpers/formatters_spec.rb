require "spec_helper"
require_relative "../../../lib/netprospex.rb"

describe NetProspex::Helpers::Formatters do
  include NetProspex::Helpers::Formatters
  describe ".unrubyize_keys" do
    it "converts snake_case to camelCase" do
      unrubyize_keys(first_name: "John", last_name: "Doe").should == {
        'firstName' => 'John',
        'lastName' => 'Doe'
      }
    end

    it "handles nested hashes" do
      unrubyize_keys(some_person: {first_name: "John", last_name: "Doe"}).should ==
        {'somePerson' => {'firstName' => 'John', 'lastName' => 'Doe'}}
    end

    it "handles array values" do
      unrubyize_keys(some_people: [
                     {first_name: "John", last_name: "Doe"},
                     {first_name: "Mary", last_name: "Smith"}
      ]).should == {'somePeople' => [
        {'firstName' => 'John', 'lastName' => 'Doe'},
        {'firstName' => 'Mary', 'lastName' => 'Smith'}
      ]}
    end
  end

  describe ".rubyize_keys" do
    it "converts camelCase to snake_case" do
      rubyize_keys({
        'firstName' => 'John',
        'lastName' => 'Doe'
      }).should == {first_name: "John", last_name: "Doe"} 
    end

    it "handles nested hashes" do
      rubyize_keys({'somePerson' =>
                   {'firstName' => 'John', 'lastName' => 'Doe'}}).should ==
        {some_person: {first_name: "John", last_name: "Doe"}}
    end

    it "handles array values" do
      rubyize_keys({'somePeople' => [
        {'firstName' => 'John', 'lastName' => 'Doe'},
        {'firstName' => 'Mary', 'lastName' => 'Smith'}
      ]}).should == {some_people: [
        {first_name: "John", last_name: "Doe"},
        {first_name: "Mary", last_name: "Smith"}
      ]}
    end
  end

  describe ".stringify_query" do
    it "is blank for empty query" do
      stringify_query(nil).should == ""
      stringify_query({}).should == ""
    end

    it "converts snake_case keys to camelCase" do
      stringify_query(first_name: "John", last_name: "Doe").should ==
        "?firstName=John&lastName=Doe"
    end

    it "escapes keys and values" do
      stringify_query('be safe?&=' => 'foo').should ==
        "?be+safe%3F%26%3D=foo"
      stringify_query(first_name: "John&doEvil=true").should ==
        "?firstName=John%26doEvil%3Dtrue"
    end

    it "handles array values" do
      stringify_query(companies: ["Apple", "Google"]).should ==
        "?companies%5B%5D=Apple&companies%5B%5D=Google"
    end
  end
end
