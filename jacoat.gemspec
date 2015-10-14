# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jacoat/version'

Gem::Specification.new do |spec|
  spec.name          = "jacoat"
  spec.version       = Jacoat::VERSION
  spec.authors       = ["Celso Fernandes"]
  spec.email         = ["fernandes@zertico.com"]

  spec.summary       = %q{Your JSON-API Coat in Ruby}
  spec.description   = %q{Handle JSON-API Hashes as Ruby Objects}
  spec.homepage      = "http://github.com/fernandes/jacoat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
