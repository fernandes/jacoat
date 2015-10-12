module Jacoat
  class Document
    class Data
      def self.from_jsonapi(arguments)
        data = Data.new
        if arguments.is_a?(Array)
          data.resource = create_resource_array(arguments)
        else
          data.resource = create_resource(arguments)
        end
        data
      end

      def self.create_resource(arguments)
        return nil if arguments.nil?
        if Detector.what_is(arguments) == "resource"
          return Resource.from_jsonapi(arguments)
        else
          return ResourceIdentifier.from_jsonapi(arguments)
        end
      end
      
      def self.create_resource_array(arguments)
        resources = []
        arguments.each do |resource|
          if Detector.what_is(resource) == "resource"
            resources << Resource.from_jsonapi(resource)
          else
            resources << ResourceIdentifier.from_jsonapi(resource)
          end
        end
        resources
      end

      attr_accessor :resource
      def resources=(resources)
        @resource = resources
      end
      def resources
        @resource
      end
      
      def to_hash
        return nil unless @resource
        if @resource.is_a?(Array)
          array = []
          @resource.each do |data|
            array << data.to_hash
          end
          return array
        else
          @resource.to_hash
        end
      end
    end
  end
end
