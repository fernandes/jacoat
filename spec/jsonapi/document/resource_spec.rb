require 'spec_helper'

describe Jsonapi::Document::Resource do
  let(:document) {
    {
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
  }
  
  describe "parses" do
    subject { described_class.new(document) }
    it "id" do
      expect(subject.id).to eq("1")
    end
    it "type" do
      expect(subject.type).to eq("articles")
    end
    context "attributes" do
      it "is a valid object" do
        expect(subject.attributes).to be_a(Jsonapi::Document::Attributes)
      end
      it "has title" do
        expect(subject.attributes.title).to eq("Rails is Omakase")
      end
    end
  end
end
