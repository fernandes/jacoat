module Jacoat
  class Document
    class Included
      def self.from_jsonapi(arguments)
        resources = []
        arguments.each do |item|
          resources << Resource.from_jsonapi(item)
        end
        included = Included.new
        included.resources = resources
        included
      end
      attr_accessor :resources
      def to_hash
        array = []
        @resources.each do |resource|
          array << resource.to_hash
        end
        return array
      end
    end
  end
end
