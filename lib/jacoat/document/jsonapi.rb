module Jacoat
  class Document
    class Jsonapi
      attr_accessor :version

      def self.from_jsonapi(arguments)
        jsonapi = Jsonapi.new
        jsonapi.version = arguments[:version]
        jsonapi
      end
      
      def to_hash
        {version: version}
      end
    end
  end
end
