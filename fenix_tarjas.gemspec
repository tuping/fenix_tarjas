# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fenix_tarjas/version'

Gem::Specification.new do |spec|
  spec.name          = "fenix_tarjas"
  spec.version       = FenixTarjas::VERSION
  spec.authors       = ["Rodrigo M. Albuquerque"]
  spec.email         = ["webrodrigo@gmail.com"]
  spec.summary       = %q{Gera arquivo pdf com tarjas para impressão.}
  spec.description   = %q{Gera arquivo pdf a partir de uma lista em csv.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "prawn", "~> 1.3.0"
  spec.add_runtime_dependency "barby"
  spec.add_runtime_dependency "rqrcode"
  spec.add_runtime_dependency "progress_bar"
  spec.add_development_dependency "warbler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 3.0"
end
