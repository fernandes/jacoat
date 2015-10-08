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
        expect(subject.data.resource.type).to eq("articles")
        expect(subject.data.resource.id).to eq("1")
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
        expect(subject.meta.copyright).to eq("Copyright 2015 Example Corp.")
        expect(subject.meta.authors.first).to eq("Yehuda Katz")
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
        # TODO: implement error
        # expect(subject.errors).to eq(document[:errors])
      end
    end
    context "compound" do
      let(:document) {
        {
          "data": [{
            "type": "articles",
            "id": "1",
            "attributes": {
              "title": "JSON API paints my bikeshed!"
            },
            "links": {
              "self": "http://example.com/articles/1"
            },
            "relationships": {
              "author": {
                "links": {
                  "self": "http://example.com/articles/1/relationships/author",
                  "related": "http://example.com/articles/1/author"
                },
                "data": { "type": "people", "id": "9" }
              },
              "comments": {
                "links": {
                  "self": "http://example.com/articles/1/relationships/comments",
                  "related": "http://example.com/articles/1/comments"
                },
                "data": [
                  { "type": "comments", "id": "5" },
                  { "type": "comments", "id": "12" }
                ]
              }
            }
          }],
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
          }, {
            "type": "comments",
            "id": "5",
            "attributes": {
              "body": "First!"
            },
            "relationships": {
              "author": {
                "data": { "type": "people", "id": "2" }
              }
            },
            "links": {
              "self": "http://example.com/comments/5"
            }
          }, {
            "type": "comments",
            "id": "12",
            "attributes": {
              "body": "I like XML better"
            },
            "relationships": {
              "author": {
                "data": { "type": "people", "id": "9" }
              }
            },
            "links": {
              "self": "http://example.com/comments/12"
            }
          }]
        }
      }
      subject { described_class.new(document) }
      context "parses" do
        it "2 resources on data" do
          expect(subject.data.resources.size).to eq(1)
        end
        it "3 resources on included" do
          expect(subject.included.resources.size).to eq(3)
        end
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
