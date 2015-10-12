module Jacoat
  class Document
    class Link
      def self.from_jsonapi(hash)
        link = Link.new
        link.process_links(hash)
        link
      end

      def initialize
        @hash = {}
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
         
      def process_links(arguments)
        return if arguments.nil?
        arguments.each_pair do |k, v|
          if v.is_a?(String)
            link = Simple.new(v)
          else
            link = Complex.new(v)
          end
          send("#{k}=", link)
        end
      end
      
      def add_link(title, href, options = {})
        if options.empty?
          link = Simple.new(href)
        else
          link = Complex.new(href: href, meta: options)
        end
        send("#{title}=", link)
        self
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
          @meta = Meta.from_jsonapi(arguments[:meta])
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
