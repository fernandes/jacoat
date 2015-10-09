require 'spec_helper'

describe Jsonapi::Document::ResourceIdentifier do
  context "with no relationships" do
    let(:document) {
      {
        "type": "articles",
        "id": "1"
      }
    }
  
    subject { described_class.process(document) }
    describe "parses" do
      it "id" do
        expect(subject.id).to eq("1")
      end
      it "type" do
        expect(subject.type).to eq("articles")
      end
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
  
  context "with a has one relationship" do
    let(:document) {
      {
        "type": "articles",
        "id": "1",
        "relationships": {
          "author": {
            "data": { "type": "people", "id": "1" }
          }
        }
      }
    }
  
    subject { described_class.process(document) }
    describe "parses" do
      it "id" do
        expect(subject.id).to eq("1")
      end
      it "type" do
        expect(subject.type).to eq("articles")
      end
      it "relationship" do
        expect(subject.relationships).to be_a(Array)
        expect(subject.relationships.first).to be_a(Jsonapi::Document::Relationship)
        expect(subject.relationships.first.type).to eq("author")
      end
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
  
  context "with a has many relationship" do
    let(:document) {
      {
        "type": "articles",
        "id": "1",
        "relationships": {
          "tags": {
            "data": [
              { "type": "tags", "id": "2" },
              { "type": "tags", "id": "3" }
            ]
          }
        }
      }
    }
  
    subject { described_class.process(document) }
    describe "parses" do
      it "id" do
        expect(subject.id).to eq("1")
      end
      it "type" do
        expect(subject.type).to eq("articles")
      end
      it "relationship" do
        expect(subject.relationships).to be_a(Array)
        expect(subject.relationships.first).to be_a(Jsonapi::Document::Relationship)
        expect(subject.relationships.first.type).to eq("tags")
      end
    end
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(document)
      end
    end
  end
end
