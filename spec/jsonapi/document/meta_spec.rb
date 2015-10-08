require 'spec_helper'

describe Jsonapi::Document::Meta do
  
  let(:document) {
    {
      "copyright": "Copyright 2015 Example Corp.",
      "authors": [
        "Yehuda Katz",
        "Steve Klabnik",
        "Dan Gebhardt",
        "Tyler Kellen"
      ]
    }
  }
  
  subject { described_class.new(document) }
  it "has copyright" do
    expect(subject.copyright).to eq(document[:copyright])
  end
  it "has authors" do
    expect(subject.authors).to eq(document[:authors])
  end
  context "render" do
    it "hash document" do
      expect(subject.to_hash).to eq(document)
    end
  end
end
