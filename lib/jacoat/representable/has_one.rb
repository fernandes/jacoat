module Jacoat
  module Representable
    class HasOne
      attr_accessor :links, :options
      
      def link(link, &block)
        @links = {} if @links.nil?
        @links[link] = block
      end
    end
  end
end
