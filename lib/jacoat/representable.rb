require 'multi_json'
require 'representable/json'
require 'representable/hash_methods'
require 'jacoat/representable/has_one'

module Jacoat
  module Representable
    attr_accessor :type
    
    def self.included(base)
      base.class_eval do
        include ::Representable
        include ::Representable::JSON
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def type(type)
        representable_attrs[:_type] = type.to_s
      end
      
      def links
      end
      
      def link(link, &block)
        representable_attrs[:_link] = {} if representable_attrs[:_link].nil?
        representable_attrs[:_link][link] = block if block_given?
      end
      
      def has_one(name, options = {}, &block)
        add_relationship(name, :_has_one, options, block)
      end
      
      def has_many(name, options = {}, &block)
        add_relationship(name, :_has_many, options, block)
      end
      
      def relationships
      end

      private
      def add_relationship(object, type, options, block)
        representable_attrs[type] = {} unless representable_attrs.has_key?(type)
        rel = HasOne.new
        rel.options = options
        rel.instance_eval(&block)
        representable_attrs[type][object] = rel
      end
    end
    
    module InstanceMethods
      def from_hash(hash, options={})
        hash = from_document(hash)
        super(hash, options.merge(:only_body => true))
      end

      def to_hash(options={})
        res = super(options.merge(:only_body => true))
        to_document(res, options)
      end
      
      private
      def from_document(hash)
        document = Jacoat::Document.from_jsonapi(symbolize_keys(hash))
        attributes = document.data.resource.attributes.hash
        attributes = from_document_set_relationships(hash, attributes)
        stringify_keys(attributes)
      end
      
      def from_document_set_relationships(hash, attributes)
        representable_attrs[:_has_one].each_key do |k|
          attributes["#{k}_id"] = hash["data"]["relationships"][k.to_s]["data"]["id"].to_i
        end
        attributes
      end
      
      def to_document(hash, options = {})
        document = Jacoat::Document.new
        document.data = generate_resource(hash)
        document.data.relationships = relationship_array(hash)
        document.links = generate_links(hash)
        document.to_hash
      end
      
      def generate_links(hash)
        lk = Jacoat::Document::Link.new
        @representable_attrs[:_link].each_pair do |link, block|
          href = represented.instance_eval(&@representable_attrs[:_link][link.to_sym])
          lk.add_link(link.to_s, href)
        end
        lk
      end
      
      def generate_resource(hash)
        id = hash.delete("id")
        res = Jacoat::Document::Resource.new(id, representable_attrs[:_type])
        res.attributes = Jacoat::Document::Attributes.new(hash)
        res
      end
      
      def relationship_array(hash)
        relationships = []
        @representable_attrs[:_has_one].each_pair do |item, object|
          rel = Jacoat::Document::Relationship.new(item.to_s)
          object.links.each_pair do |k, block|
            href = represented.instance_eval(&block)
            rel.links = Jacoat::Document::Link.new.add_link(k.to_s, href)
          end
          relationships.push(rel)
        end
        relationships
      end

      def symbolize_keys(hash)
        hash.inject({}){|result, (key, value)|
          new_key = case key
                    when String then key.to_sym
                    else key
                    end
          new_value = case value
                      when Hash then symbolize_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end
      
      def stringify_keys(hash)
        hash.inject({}){|result, (key, value)|
          new_key = case key
                    when Symbol then key.to_s
                    else key
                    end
          new_value = case value
                      when Hash then symbolize_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end
    end
  end
end
