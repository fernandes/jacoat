# Jacoat

[![Build Status](https://travis-ci.org/fernandes/jacoat.svg)](https://travis-ci.org/fernandes/jacoat)

Jacoat is a Ruby Coat for your JSON-API Hashes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jacoat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jacoat

## Usage

Consider you have a have like this one:

```ruby
{
  "type": "articles",
  "id": "1",
  "attributes": {
    "title": "Rails is Omakase"
  },
  "relationships": {
    "author": {
      "links": {
        "self": "/articles/1/relationships/author",
        "related": "/articles/1/author"
      },
      "data": { "type": "people", "id": "9" }
    }
  }
}
```

You can just:

```ruby
Jacoat::Document.new(hash)
```

And you will have your JSON-API hash parsed to Ruby Objects, then you can access your document properties like this:

```ruby
document.data.resource.attributes
# => #<Jacoat::Document::Attributes:0x007fb9223b92b8 @hash={:title=>"Rails is Omakase"}>
```

Considering you want to change your title attribute to "Jacoat is a cool gem"

```ruby
document.data.resource.attributes.title = "Jacoat is a cool gem"
# => "Jacoat is a cool gem"
```

And know you what to generate your JSON-API hash again, here we go...

```ruby
document.to_hash
# => {
#   :data=>{
#     :type=>"articles",
#     :id=>"1",
#     :attributes=>{
#       :title=>"Jacoat is a cool gem"
#     },
#     :relationships=>{
#       :author=>{
#         :links=>{
#           :self=>"/articles/1/relationships/author",
#           :related=>"/articles/1/author"
#         },
#         :data=>{
#           :type=>"people",
#           :id=>"9"
#         }
#       }
#     }
#   }
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

You know how to do it! ;)

Bug reports and pull requests are welcome on GitHub at https://github.com/fernandes/jacoat.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

