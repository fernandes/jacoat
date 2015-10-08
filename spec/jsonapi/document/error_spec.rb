require 'spec_helper'

describe Jsonapi::Document::Error do
  let(:document) {
    {
      "id": "100",
      "links": {
        "about": "http://site.com/errors/100"
      },
      "status": "401",
      "code": "007",
      "title": "A minor error",
      "detail": "this is an error cause by a object validation",
      # TODO: implement source
      # "source": {
      #   "pointer": "/data",
      #   "parameter": "name"
      # },
      "meta": {
        "copyright": "Copyright 2015 Example Corp." 
      }
    }
  }
  subject { described_class.new(document) }
  it "has id" do
    expect(subject.id).to eq(document[:id])
  end
  it "has links" do
    expect(subject.links.about.href).to eq(document[:links][:about])
  end
  it "has status" do
    expect(subject.status).to eq(document[:status])
  end
  it "has code" do
    expect(subject.code).to eq(document[:code])
  end
  it "has title" do
    expect(subject.title).to eq(document[:title])
  end
  it "has details" do
    expect(subject.detail).to eq(document[:detail])
  end
  it "has meta" do
    expect(subject.meta.copyright).to eq(document[:meta][:copyright])
  end
  context "render" do
    it "hash document" do
      expect(subject.to_hash).to eq(document)
    end
  end
end
