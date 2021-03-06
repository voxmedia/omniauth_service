# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth_service/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth_service"
  spec.version       = OmniauthService::VERSION
  spec.authors       = ["Skip Baney"]
  spec.email         = ["skip@voxmedia.com"]
  spec.description   = %q{Utility service for managing omniauth providers in an application.}
  spec.summary       = %q{Utility service for managing omniauth providers in an application.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activerecord", "~> 3.2"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
