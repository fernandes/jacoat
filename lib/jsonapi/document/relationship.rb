module Jsonapi
  class Document
    class Relationship
      attr_reader :id, :type, :data, :links
      def self.process(hash)
        relationships = []
        hash.each_pair do |k, v|
          relationships << Document::Relationship.new(k, v)
        end
        relationships
      end

      def initialize(type, body)
        @type = type.to_s
        process_data(body[:data])
        process_body(body[:links]) if body.has_key?(:links)
      end
      
      def process_data(data)
        @data = Document::ResourceIdentifier.process(data)
      end

      def process_body(links)
        @links = Document::Link.process(links)
      end
    end
  end
end
