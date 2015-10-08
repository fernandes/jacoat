module Jsonapi
  class Document
    class Included
      def self.process(arguments)
        resources = []
        arguments.each do |item|
          resources << Resource.new(item)
        end
        included = Included.new
        included.resources = resources
        included
      end
      attr_accessor :resources
      def initialize(arguments = {})
      end
    end
  end
end
