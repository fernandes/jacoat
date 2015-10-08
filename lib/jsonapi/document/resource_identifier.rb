module Jsonapi
  class Document
    class ResourceIdentifier
      attr_reader :id, :type
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
      end
      
      def to_hash
        {
          type: @type,
          id: @id
        }
      end
    end
  end
end
