module Jacoat
  class Document
    class Relationship
      attr_reader :id, :type, :data, :links
      def self.from_jsonapi(hash)
        relationships = []
        hash.each_pair do |k, v|
          relationship = Document::Relationship.new(k)
          relationship.process_jsonapi(v)
          relationships << relationship
        end
        relationships
      end

      def initialize(type)
        @type = type.to_s
      end
      
      def to_hash
        hash = {}
        hash[type.to_sym] = {}
        hash[type.to_sym].merge!(links: @links.to_hash) if @links
        hash[type.to_sym].merge!(data: data_to_hash) if @data
        hash
      end
      
      def process_jsonapi(hash)
        process_data(hash[:data]) if hash.has_key?(:data)
        process_body(hash[:links]) if hash.has_key?(:links)
        self
      end

      private
        def process_data(data)
          @data = Document::ResourceIdentifier.from_jsonapi(data)
        end

        def process_body(links)
          @links = Document::Link.from_jsonapi(links)
        end

        def data_to_hash
          if @data.is_a?(Array)
            array = []
            @data.each do |data|
              array << data.to_hash
            end
            return array
          else
            @data.to_hash
          end
        end
    end
  end
end
