require 'jacoat/document/data'
require 'jacoat/document/error'
require 'jacoat/document/meta'
require 'jacoat/document/attribute'
require 'jacoat/document/jsonapi'
require 'jacoat/document/link'
require 'jacoat/document/included'
require 'jacoat/document/resource_identifier'
require 'jacoat/document/resource'
require 'jacoat/document/relationship'

module Jacoat
  class Document
    attr_reader :data
    attr_accessor :errors, :meta, :jsonapi, :links, :included

    def self.from_jsonapi(arguments)
      document = Document.new
      document.data = Data.from_jsonapi(arguments[:data]) if arguments.has_key?(:data)
      
      
      document.errors = Error.from_jsonapi(arguments[:errors]) if arguments.has_key?(:errors)
      document.meta = Meta.from_jsonapi(arguments[:meta]) if arguments.has_key?(:meta)
      document.jsonapi = Jsonapi.from_jsonapi(arguments[:jsonapi]) if arguments.has_key?(:jsonapi)
      document.links = Link.from_jsonapi(arguments[:links]) if arguments.has_key?(:links)
      document.included = Included.from_jsonapi(arguments[:included]) if arguments.has_key?(:included)
      document
    end

    def data=(data)
      @has_data = true
      @data = data
    end

    def valid?
      validate_arguments
      true
    rescue Invalid
      return false
    end

    def validate_arguments
      raise Invalid.new('included key without data key') if @included && !@data
      raise Invalid.new('must contain data, errors or meta key') if !@data && !@errors && !@meta
      raise Invalid.new('data and errors keys set') if @data && @errors
    end
    
    def to_hash
      hash = {}
      hash[:data] = data_hash if @has_data
      %w{ errors meta jsonapi links included }.each do |type|
        if self.instance_variable_defined?("@#{type}".to_sym)
          hash[type.to_sym] = instance_variable_get("@#{type}".to_sym).to_hash
        end
      end
      hash
    end
    
    def data_hash
      return nil if @data.nil? and @has_data
      if @data.is_a?(Array)
        array = []
        @data.each do |data|
          array << data.to_hash
        end
        return array
      else
        @data.to_hash
      end
    end
    
    class Invalid < Exception; end
  end
end
