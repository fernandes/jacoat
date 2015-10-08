module Jsonapi
  class Document
    class Attributes
      def initialize(arguments = {})
        @hash = arguments
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
