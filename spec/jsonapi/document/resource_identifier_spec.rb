require 'spec_helper'

describe Jsonapi::Document::ResourceIdentifier do
  let(:document) {
    {
      "type": "articles",
      "id": "1"
    }
  }
  
  subject { described_class.new(document) }
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
