module Jsonapi
  class Document
    class Resource
      attr_reader :id, :type, :attributes, :links
      def initialize(arguments)
        @id = arguments[:id]
        @type = arguments[:type]
        @attributes = Document::Attributes.new(arguments[:attributes])
        create_relationships(arguments[:relationships]) if arguments.has_key?(:relationships)
        @links = Link.process(arguments[:links]) if arguments.has_key?(:links)
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
