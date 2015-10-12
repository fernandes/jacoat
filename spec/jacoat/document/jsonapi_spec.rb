require 'spec_helper'

describe Jacoat::Document::Jsonapi do
  let(:document) {
    {
      "version": "1.0"
    }
  }
  subject { described_class.from_jsonapi(document) }
  it "has version" do
    expect(subject.version).to eq("1.0")
  end
  context "render" do
    it "hash document" do
      expect(subject.to_hash).to eq(document)
    end
  end
end
