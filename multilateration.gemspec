# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multilateration/version'

Gem::Specification.new do |spec|
  spec.name          = "multilateration"
  spec.version       = Multilateration::VERSION
  spec.authors       = ["Arron Mabrey"]
  spec.email         = ["arron@mabreys.com"]
  spec.description   = %q{Solves for the location of an unknown signal emitter by using the signal TDOA between multiple signal receivers with known locations.}
  spec.summary       = %q{Solves for the location of an unknown signal emitter by using the signal TDOA between multiple signal receivers with known locations.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
