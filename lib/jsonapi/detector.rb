module Jsonapi
  module Detector
    def self.what_is(hash)
      return "compound" if is_compound?(hash)
      return "document" if is_document?(hash)
      return "resource" if is_resource?(hash)
      return "resource_identifier" if is_resource_identifier?(hash)
    end
    
    def self.is_compound?(hash)
      return true if hash.has_key?(:data) and hash.has_key?(:included) and hash[:data].is_a?(Array)
    end

    def self.is_document?(hash)
      return true if hash.has_key?(:data) and !hash[:data].is_a?(Array)
      return true if hash.has_key?(:errors)
      return true if hash.has_key?(:meta)
    end

    def self.is_resource_identifier?(hash)
      return true if hash.has_key?(:type) &&
                     hash.has_key?(:id) &&
                     !hash.has_key?(:attributes)
                     !hash.has_key?(:relationships)
    end
    
    def self.is_resource?(hash)
      return true if hash.has_key?(:type) &&
                     hash.has_key?(:id) &&
                     hash.has_key?(:attributes)
    end
  end
end
