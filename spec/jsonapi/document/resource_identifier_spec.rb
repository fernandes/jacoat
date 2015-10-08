require 'spec_helper'

describe Jsonapi::Document::ResourceIdentifier do
  let(:document) {
    {
      "type": "articles",
      "id": "1"
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
  end
end
