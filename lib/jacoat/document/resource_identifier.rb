module Jacoat
  class Document
    class ResourceIdentifier
      attr_accessor :id, :type, :relationships
      def self.from_jsonapi(body)
        if body.is_a?(Array)
          resources = []
          body.each do |item|
            resources << ResourceIdentifier.new(item[:id], item[:type]).process_jsonapi(item)
          end
        else
          resources = ResourceIdentifier.new(body[:id], body[:type]).process_jsonapi(body)
        end
        resources
      end

      def initialize(id, type)
        @id = id
        @type = type
      end
      
      def process_jsonapi(arguments)
        create_relationships(arguments[:relationships]) if arguments.has_key?(:relationships)
        self
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
          id: @id
        }
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
