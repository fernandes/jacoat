module Jsonapi
  class Document
    class ResourceIdentifier
      attr_reader :id, :type, :relationships
      def self.process(body)
        if body.is_a?(Array)
          resources = []
          body.each do |item|
            resources << ResourceIdentifier.new(item)
          end
        else
          resources = ResourceIdentifier.new(body)
        end
        resources
      end

      def initialize(arguments)
        @id = arguments[:id]
        @type = arguments[:type]
        create_relationships(arguments[:relationships]) if arguments.has_key?(:relationships)
      end

      def create_relationships(hash)
        @relationships = []
        hash.each_pair do |k, v|
          @relationships << Document::Relationship.new(k, v)
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
