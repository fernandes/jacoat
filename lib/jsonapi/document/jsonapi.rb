module Jsonapi
  class Document
    class Jsonapi
      attr_reader :version
      def initialize(arguments = {})
        @version = arguments[:version]
      end
    end
  end
end
