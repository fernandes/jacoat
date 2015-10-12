require 'spec_helper'
require 'ostruct'
require 'jacoat/representable'

describe Jacoat::Representable do
  # Articles
  # has one Author (can be used for has one and belongs to relations)
  # has many Comments

  context "single resource" do
    module Representer
      include Jacoat::Representable

      type :articles

      property :id
      property :title
      property :author_id

      link :self do
        "http://example.com/articles/#{represented.id}"
      end

      has_one :author, type: :people do
        link :related do
          "http://example.com/articles/#{represented.id}/author"
        end
      end
    end

    let(:request) {
      {
        "data": {
          "type": "articles",
          "attributes": {
            "title": "JSON API paints my bikeshed!"
          },
          "relationships": {
            "author": {
              "data": { "type": "people", "id": "9" }
            }
          }
        }
      }
    }
    let(:response) {
      {
        "data": {
          "type": "articles",
          "id": "1",
          "attributes": {
            "title": "JSON API paints my bikeshed!"
          },
          "relationships": {
            "author": {
              "links": {
                "related": "http://example.com/articles/1/author"
              }
            }
          }
        },
        "links": {
          "self": "http://example.com/articles/1"
        }
      }
    }
    subject { Representer.prepare(OpenStruct.new) }
    it "parse object" do
      article = subject.from_json(request.to_json)
      expect(article.title).to eq("JSON API paints my bikeshed!")
      # TODO: needs to set author_id based on
      # "data": { "type": "people", "id": "1" }
      # we do it with property :author or handling has_one ?
      # current handling on has_one
      expect(article.author_id).to eq(9)
    end

    let(:author_object) { OpenStruct.new(first_name: "Celso", last_name: "Fernandes", twitter: "celsovjf") }
    let(:article_object) { OpenStruct.new(id: 1, title: "JSON API paints my bikeshed!", author: nil) }
    subject { Representer.prepare(article_object) }
    it "render object" do
      expect(subject.to_json).to eq(response.to_json)
    end
  end
end
