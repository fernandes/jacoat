require 'spec_helper'

describe Jacoat::Document::Attributes do
  let(:document) {
    {
      "title": "Ember Hamster",
      "src": "http://example.com/images/productivity.png"
    }
  }
  subject { described_class.new(document) }
  context "created" do
    it "has title" do
      expect(subject.title).to eq("Ember Hamster")
    end
    
    it "has src" do
      expect(subject.src).to eq("http://example.com/images/productivity.png")
    end
  end
  context "render" do
    it "hash document" do
      expect(subject.to_hash).to eq(document)
    end
  end
  
  context "with invalid attributes" do
    let(:document) {
      {
        "title": "Ember Hamster",
        "src": nil
      }
    }
    let(:rendered) {
      {
        "title": "Ember Hamster"
      }
    }
    subject { described_class.new(document) }
    context "render" do
      it "hash document" do
        expect(subject.to_hash).to eq(rendered)
      end
    end
  end
end
