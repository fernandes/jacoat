module Jsonapi
  class Document
    class Attributes
      # attr_reader :self, :related
      def initialize(arguments = {})
        @hash = arguments
        # %w{ self related }.each do |type|
        #   self.instance_variable_set("@#{type}", arguments[type.to_sym])
        # end
      end
      
      def method_missing(m, *args)
        #setter
        if /^(\w+)=$/ =~ m 
          @hash[:"#{$1}"] = args[0]
        end
        #getter
        @hash[:"#{m}"]
      end
    end
  end
end
