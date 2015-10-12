module Jacoat
  class Document
    class Attributes
      attr_reader :hash

      def self.from_jsonapi(arguments = {})
        Attributes.new(arguments)
      end

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
      
      def to_hash
        proc = Proc.new { |k, v| v.kind_of?(Hash) ? (v.delete_if(&proc); nil) : v.nil? }; @hash.delete_if(&proc)
      end
    end
  end
end
