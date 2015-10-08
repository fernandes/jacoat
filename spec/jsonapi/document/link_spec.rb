require 'spec_helper'

describe Jsonapi::Document::Link do
  context ".process" do
    let(:document) {
      {
        "self": "http://example.com/posts",
        "related": {
          "href": "http://example.com/articles/1/comments",
           "meta": {
             "count": 10
           }
        }
      }
    }
    subject { described_class.process(document) }
    context "first link" do
      it "is a simple one" do
        expect(subject.self.class).to eq(described_class::Simple)
      end
      it "has href" do
        expect(subject.self.href).to eq("http://example.com/posts")
      end
    end
    context "second link" do
      it "is a complex one" do
        expect(subject.related.class).to eq(described_class::Complex)
      end
      it "has href" do
        expect(subject.related.href).to eq("http://example.com/articles/1/comments")
      end
      it "has meta" do
        expect(subject.related.meta).to be_a(Jsonapi::Document::Meta)
      end
      it "has meta count" do
        expect(subject.related.meta.count).to eq(10)
      end
    end
  end
end
