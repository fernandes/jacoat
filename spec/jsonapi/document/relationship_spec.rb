require 'spec_helper'

describe Jsonapi::Document::Relationship do
  context ".process" do
    let(:document) {
      {
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
    subject {described_class.process(document) }
    it "create 2 relationships" do
      expect(subject.size).to eq(2)
    end
    it "with correct types" do
      expect(subject[0].type).to eq("author")
      expect(subject[1].type).to eq("comments")
    end
  end

  context "has one" do
    let(:document) {
      {
        "links": {
          "self": "/articles/1/relationships/author",
          "related": "/articles/1/author"
        },
        "data": { "type": "people", "id": "9" }
      }
    }
  
    describe "parses" do
      subject { described_class.new("author", document) }
      it "type" do
        expect(subject.type).to eq("author")
      end
      
      it "data" do
        expect(subject.data.class).to eq(Jsonapi::Document::ResourceIdentifier)
      end
      it "data has type" do
        expect(subject.data.type).to eq("people")
      end
      it "data has id" do
        expect(subject.data.id).to eq("9")
      end
    end
  end
  
  context "has many" do
    let(:document) {
      {
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
  
    describe "parses" do
      subject { described_class.new("comments", document) }
      it "type" do
        expect(subject.type).to eq("comments")
      end
      context "links" do
        context "first one" do
          it "has href" do
            expect(subject.links.self.href).to eq("http://example.com/articles/1/relationships/comments")
          end
        end
        context "second one" do
          it "has href" do
            expect(subject.links.related.href).to eq("http://example.com/articles/1/comments")
          end
        end
      end
      context "data" do
        it "data" do
          expect(subject.data.class).to eq(Array)
          expect(subject.data.size).to eq(2)
        end
        context "first item" do
          it "has type" do
            expect(subject.data[0].type).to eq("comments")
          end
          it "has id" do
            expect(subject.data[0].id).to eq("5")
          end
        end
        context "second item" do
          it "has type" do
            expect(subject.data[1].type).to eq("comments")
          end
          it "has id" do
            expect(subject.data[1].id).to eq("12")
          end
        end
      end
    end
  end
end
