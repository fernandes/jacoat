require 'spec_helper'

describe Jacoat::Document::Data do
  context "single resource" do
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
    subject { described_class.process(document) }
    it "is parsed" do
      expect(subject.resource.class).to eq(Jacoat::Document::Resource)
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
  
  context "single resource identifier" do
    let(:document) {
      { "type": "people", "id": "12" }
    }
    subject { described_class.process(document) }
    it "is parsed" do
      expect(subject.resource.class).to eq(Jacoat::Document::ResourceIdentifier)
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
  
  context "array of resources" do
    let(:document) {
      [
        {
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
        }
      ]
    }
    subject { described_class.process(document) }
    it "is parsed" do
      expect(subject.resource.class).to eq(Array)
      expect(subject.resource.first.class).to eq(Jacoat::Document::Resource)
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
  
  context "array of resource identifiers" do
    let(:document) {
      [
        { "type": "tags", "id": "2" },
        { "type": "tags", "id": "3" }
      ]
    }
    subject { described_class.process(document) }
    it "is parsed" do
      expect(subject.resource.class).to eq(Array)
      expect(subject.resource.first.class).to eq(Jacoat::Document::ResourceIdentifier)
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
end
