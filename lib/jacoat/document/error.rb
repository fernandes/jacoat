module Jacoat
  class Document
    class Error
      attr_accessor :id, :links, :status, :code, :title, :detail, :meta
      def self.from_jsonapi(arguments)
        error = Error.new
        error.id = arguments[:id]
        error.links = Link.from_jsonapi(arguments[:links]) if arguments.has_key?(:links)
        %w{ status code title detail }.each do |type|
          error.instance_variable_set("@#{type}", arguments[type.to_sym]) if arguments.has_key?(type.to_sym)
        end
        error.meta = Meta.from_jsonapi(arguments[:meta]) if arguments.has_key?(:meta)
        error
      end
      
      def to_hash
        hash = {}
        hash[:id] = @id if @id
        hash[:links] = @links.to_hash if @links
        %w{ status code title detail }.each do |type|
          if self.instance_variable_defined?("@#{type}".to_sym)
            hash[type.to_sym] = instance_variable_get("@#{type}".to_sym)
          end
        end
        hash[:meta] = @meta.to_hash if @meta
        hash
      end
    end
  end
end
