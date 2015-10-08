require 'spec_helper'

describe Jsonapi::Document::Jsonapi do
  let(:document) {
    {
      "version": "1.0"
    }
  }
  subject { described_class.new(document) }
  it "has version" do
    expect(subject.version).to eq("1.0")
  end
end
