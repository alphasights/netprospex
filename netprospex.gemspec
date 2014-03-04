# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netprospex/version'

Gem::Specification.new do |gem|
  gem.name          = 'netprospex-ruby'
  gem.version       = NetProspex::VERSION
  gem.authors       = ['Michael Limiero']
  gem.email         = ['mike5713@gmail.com']
  gem.homepage      = 'https://github.com/SalesLoft/netprospex-ruby'
  gem.summary       = %q{Ruby bindings for NetProspex API}
  gem.description   = %q{The NetProspex API provides search and lookup for detailed information on people and companies.}
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'vcr'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'faraday'
  gem.add_runtime_dependency 'faraday_middleware'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'simple_oauth'
end
