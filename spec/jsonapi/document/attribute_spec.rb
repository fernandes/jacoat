require 'spec_helper'

describe Jsonapi::Document::Attributes do
  let(:document) {
    {
      "title": "Ember Hamster",
      "src": "http://example.com/images/productivity.png"
    }
  }
  context "created" do
    subject { described_class.new(document) }
    it "has title" do
      expect(subject.title).to eq("Ember Hamster")
    end
    
    it "has src" do
      expect(subject.src).to eq("http://example.com/images/productivity.png")
    end
  end
end
