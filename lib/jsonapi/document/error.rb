module Jsonapi
  class Document
    class Errors
      # attr_reader :self, :related
      def initialize(arguments = {})
        # %w{ self related }.each do |type|
        #   self.instance_variable_set("@#{type}", arguments[type.to_sym])
        # end
      end
    end
  end
end
