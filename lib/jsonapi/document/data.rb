module Jsonapi
  class Document
    class Data
      def self.process(arguments)
        data = Data.new
        if arguments.is_a?(Array)
          data.resource = create_resource_array(arguments)
        else
          data.resource = create_resource(arguments)
        end
        data
      end

      def self.create_resource(arguments)
        if Detector.what_is(arguments) == "resource"
          return Resource.new(arguments)
        else
          return ResourceIdentifier.new(arguments)
        end
      end
      
      def self.create_resource_array(arguments)
        resources = []
        arguments.each do |resource|
          if Detector.what_is(resource) == "resource"
            resources << Resource.new(resource)
          else
            resources << ResourceIdentifier.new(resource)
          end
        end
        resources
      end

      attr_accessor :resource
      
      def initialize(arguments = {})
      end
      
      def resources
        @resource
      end
    end
  end
end
