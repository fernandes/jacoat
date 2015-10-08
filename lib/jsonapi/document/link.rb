module Jsonapi
  class Document
    class Link
      def self.process(hash)
        Link.new(hash)
      end

      def initialize(arguments = {})
        @hash = {}
        process_links(arguments)
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
        hash = {}
        @hash.each_pair do |k, v|
          hash[k] = v.to_hash
        end
        hash
      end
      
      private      
        def process_links(arguments)
          arguments.each_pair do |k, v|
            if v.is_a?(String)
              link = Simple.new(v)
            else
              link = Complex.new(v)
            end
            send("#{k}=", link)
          end
        end
      
      class Simple
        attr_reader :href
        def initialize(href)
          @href = href
        end
        
        def to_hash
          href
        end
      end
      
      class Complex
        attr_reader :href, :meta
        def initialize(arguments)
          @href = arguments[:href]
          @meta = Meta.new(arguments[:meta])
        end
        
        def to_hash
          hash = {}
          hash.merge!(href: href) if @href
          hash.merge!(meta: meta.to_hash) if @meta
          hash
        end
      end
    end
  end
end
