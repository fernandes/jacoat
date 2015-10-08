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
      
      def to_hash
        hash = {}
        hash[type.to_sym] = {}
        hash[type.to_sym].merge!(links: @links.to_hash) if @links
        hash[type.to_sym].merge!(data: data_to_hash) if @data
        hash
      end
      
      private
        def process_data(data)
          @data = Document::ResourceIdentifier.process(data)
        end

        def process_body(links)
          @links = Document::Link.process(links)
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
