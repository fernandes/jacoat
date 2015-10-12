module Jacoat
  class Document
    class Jsonapi
      attr_reader :version
      def initialize(arguments = {})
        @version = arguments[:version]
      end
      
      def to_hash
        {version: version}
      end
    end
  end
end
