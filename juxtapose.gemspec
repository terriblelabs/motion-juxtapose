# coding: utf-8
require File.expand_path('../lib/juxtapose/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "juxtapose"
  spec.version       = Juxtapose::VERSION
  spec.authors       = ["Joe Lind", "Thomas Mayfield"]
  spec.email         = ["thomas@terriblelabs.com"]
  spec.description   = %q{Screenshot-based assertions for RubyMotion projects}
  spec.summary       = %q{Screenshot-based assertions for RubyMotion projects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", "~> 1.4"
  spec.add_dependency "haml"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakefs"
end
