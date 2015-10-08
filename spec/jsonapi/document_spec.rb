require 'spec_helper'

describe Jsonapi::Document do
  context "valid" do
    context "with data" do
      let(:document) {{
        "data": {
          "type": "articles",
          "id": "1"
        }
      }}
      subject { described_class.new(document) }
      it "sets" do
        expect(subject.data).to eq(document[:data])
      end
    end
    context "with meta" do
      let(:document) {{
        "meta": {
          "copyright": "Copyright 2015 Example Corp.",
          "authors": [
            "Yehuda Katz",
            "Steve Klabnik",
            "Dan Gebhardt",
            "Tyler Kellen"
          ]
        }
      }}
      subject { described_class.new(document) }
      it "sets" do
        expect(subject.meta).to eq(document[:meta])
      end
    end
    context "with errors" do
      let(:document) {{
        "errors": {
          "code": "100"
        }
      }}
      subject { described_class.new(document) }
      it "sets" do
        expect(subject.errors).to eq(document[:errors])
      end
    end
  end
  
  context "invalid" do
    context "with data and errors key" do
      let(:document) {{
        "data": {
          "type": "articles",
          "id": "1"
        },
        "errors": {
          "code": "100"
        }
      }}
      it "raise Exception" do
        expect { described_class.new(document) }.to raise_error(Jsonapi::Document::Invalid, /data and errors keys set/)
      end
    end
    
    context "with no data, error or meta key" do
      let(:document) {{
        "boom": {
          "type": "articles",
          "id": "1"
        },
        "links": {
          "code": "100"
        }
      }}
      it "raise Exception" do
        expect { described_class.new(document) }.to raise_error(Jsonapi::Document::Invalid, /must contain data, errors or meta key/)
      end
    end
    
    context "with included and no data" do
      let(:document) {{
        "included": [{
          "type": "people",
          "id": "9",
          "attributes": {
            "first-name": "Dan",
            "last-name": "Gebhardt",
            "twitter": "dgeb"
          },
          "links": {
            "self": "http://example.com/people/9"
          }
        }]
      }}
      it "raise Exception" do
        expect { described_class.new(document) }.to raise_error(Jsonapi::Document::Invalid, /included key without data key/)
      end
    end
  end
end
