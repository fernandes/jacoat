module Jacoat
  class Document
    class Meta
      def initialize(arguments = {})
        @hash = {}
        process_meta(arguments)
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
        @hash
      end
      
      private
        def process_meta(arguments)
          arguments.each_pair do |k, v|
            send("#{k}=", v)
          end
        end
    end
  end
end
