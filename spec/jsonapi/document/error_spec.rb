require 'spec_helper'

describe Jsonapi::Document::Errors do
  # TODO: Finish
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
      "source": {
        "pointer": "/data",
        "parameter": "name"
      },
      "meta": {
        "copyright": "Copyright 2015 Example Corp." 
      }
    }
  }
end
