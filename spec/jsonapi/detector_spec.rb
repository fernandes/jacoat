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
