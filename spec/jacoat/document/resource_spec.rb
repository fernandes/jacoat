require 'spec_helper'

describe Jacoat::Document::Resource do
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
  
  subject { described_class.from_jsonapi(document) }

  describe "parses" do
    it "id" do
      expect(subject.id).to eq("1")
    end
    it "type" do
      expect(subject.type).to eq("articles")
    end
    context "attributes" do
      it "is a valid object" do
        expect(subject.attributes).to be_a(Jacoat::Document::Attributes)
      end
      it "has title" do
        expect(subject.attributes.title).to eq("Rails is Omakase")
      end
    end
  end
  
  describe "render" do
    it "hash document" do
      expect(subject.to_hash).to eq(document)
    end
  end
end
