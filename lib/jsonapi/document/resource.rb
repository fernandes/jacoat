module Jsonapi
  class Document
    class Resource
      attr_reader :id, :type, :attributes
      def initialize(arguments)
        @id = arguments[:id]
        @type = arguments[:type]
        @attributes = Document::Attributes.new(arguments[:attributes])
        create_relationships(arguments[:relationships])
      end
      
      def create_relationships(hash)
        @relationships = []
        hash.each_pair do |k, v|
          @relationships << Document::Relationship.new(k, v)
        end
      end
    end
  end
end
