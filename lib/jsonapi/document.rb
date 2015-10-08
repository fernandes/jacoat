require 'jsonapi/document/data'
require 'jsonapi/document/error'
require 'jsonapi/document/meta'
require 'jsonapi/document/attribute'
require 'jsonapi/document/jsonapi'
require 'jsonapi/document/link'
require 'jsonapi/document/included'
require "jsonapi/document/resource_identifier"
require "jsonapi/document/resource"
require "jsonapi/document/relationship"

module Jsonapi
  class Document
    attr_reader :data, :errors, :meta, :jsonapi, :links, :included
    def initialize(arguments = {})
      validate_arguments(arguments)
      @data = Data.process(arguments[:data]) if arguments.has_key?(:data)
      @errors = Error.new(arguments[:errors]) if arguments.has_key?(:errors)
      @meta = Meta.new(arguments[:meta]) if arguments.has_key?(:meta) 
      @jsonapi = Jsonapi.new(arguments[:jsonapi]) if arguments.has_key?(:jsonapi)
      @links = Link.process(arguments[:links]) if arguments.has_key?(:links)
      @included = Included.process(arguments[:included]) if arguments.has_key?(:included)
    end
    
    def validate_arguments(arguments)
      raise Invalid.new('included key without data key') if arguments.has_key?(:included) && !arguments.has_key?(:data)
      raise Invalid.new('must contain data, errors or meta key') if !arguments.has_key?(:data) && !arguments.has_key?(:errors) && !arguments.has_key?(:meta)
      raise Invalid.new('data and errors keys set') if arguments.has_key?(:data) && arguments.has_key?(:errors)
    end
    
    class Invalid < Exception; end
  end
end
