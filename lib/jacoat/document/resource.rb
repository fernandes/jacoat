module Jacoat
  class Document
    class Resource
      attr_accessor :id, :type, :attributes, :links, :relationships

      def self.from_jsonapi(arguments)
        resource = Resource.new(arguments[:id], arguments[:type])
        resource.attributes = Document::Attributes.from_jsonapi(arguments[:attributes])
        resource.create_relationships(arguments[:relationships]) if arguments.has_key?(:relationships)
        resource.links = Link.from_jsonapi(arguments[:links]) if arguments.has_key?(:links)
        resource
      end

      def initialize(id, type)
        @id = id
        @type = type
      end
      
      def create_relationships(hash)
        @relationships = []
        hash.each_pair do |k, v|
          @relationships << Document::Relationship.new(k).process_jsonapi(v)
        end
      end
      
      def to_hash
        hash = {
          type: @type,
          id: @id.to_s,
          attributes: @attributes.to_hash
        }
        hash.merge!(links: @links.to_hash) if @links
        hash.merge!(relationships: relationship_hash) if @relationships
        hash
      end
      
      def relationship_hash
        hash = {}
        @relationships.each do |relationship|
          hash.merge!(relationship.to_hash)
        end
        hash
      end
    end
  end
end
