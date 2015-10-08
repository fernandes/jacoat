require 'spec_helper'

describe Jsonapi::Detector do
  describe "detects" do
    describe "document" do
      it "with data" do
        document = {
          "data": {
            "type": "articles",
            "id": "1"
          }
        }
        expect(described_class.what_is(document)).to eq('document')
      end
      it "with meta" do
        document = {
          "meta": {
            "copyright": "Copyright 2015 Example Corp.",
            "authors": [
              "Yehuda Katz",
              "Steve Klabnik",
              "Dan Gebhardt",
              "Tyler Kellen"
            ]
          }
        }
        expect(described_class.what_is(document)).to eq('document')
      end
      it "with errors" do
        document = {
          "errors": {
            "id": "100"
          }
        }
        expect(described_class.what_is(document)).to eq('document')
      end
    end
    
    it "coumpound document" do
      document = {
        "data": [{
          "type": "articles",
          "id": "1",
          "attributes": {
            "title": "JSON API paints my bikeshed!"
          },
          "links": {
            "self": "http://example.com/articles/1"
          },
          "relationships": {
            "author": {
              "links": {
                "self": "http://example.com/articles/1/relationships/author",
                "related": "http://example.com/articles/1/author"
              },
              "data": { "type": "people", "id": "9" }
            },
            "comments": {
              "links": {
                "self": "http://example.com/articles/1/relationships/comments",
                "related": "http://example.com/articles/1/comments"
              },
              "data": [
                { "type": "comments", "id": "5" },
                { "type": "comments", "id": "12" }
              ]
            }
          }
        }],
        "included": [{
          "type": "people",
          "id": "9",
          "attributes": {
            "first-name": "Dan",
            "last-name": "Gebhardt",
            "twitter": "dgeb"
          },
          "links": {
            "self": "http://example.com/people/9"
          }
        }, {
          "type": "comments",
          "id": "5",
          "attributes": {
            "body": "First!"
          },
          "relationships": {
            "author": {
              "data": { "type": "people", "id": "2" }
            }
          },
          "links": {
            "self": "http://example.com/comments/5"
          }
        }, {
          "type": "comments",
          "id": "12",
          "attributes": {
            "body": "I like XML better"
          },
          "relationships": {
            "author": {
              "data": { "type": "people", "id": "9" }
            }
          },
          "links": {
            "self": "http://example.com/comments/12"
          }
        }]
      }
      
      expect(described_class.what_is(document)).to eq('compound')
    end

    it "resource identifier" do
      document = {
        "type": "articles",
        "id": "1"
      }
      expect(described_class.what_is(document)).to eq('resource_identifier')
    end
    
    it "resource" do
      document = {
        "type": "articles",
        "id": "1",
        "attributes": {
          "title": "Rails is Omakase"
        },
        "relationships": {
          "author": {
            "links": {
              "self": "/articles/1/relationships/author",
              "related": "/articles/1/author"
            },
            "data": { "type": "people", "id": "9" }
          }
        }
      }
      expect(described_class.what_is(document)).to eq('resource')
    end
    
  end
end
