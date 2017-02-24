# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/laravel/version"

Gem::Specification.new do |spec|
  spec.name          = "capistrano-laravel"
  spec.version       = Capistrano::Laravel::VERSION
  spec.authors       = ["Peter Mitchell", "Andrew Miller"]
  spec.email         = ["peterjmit@gmail.com", "ikari7789@yahoo.com"]

  spec.summary       = "Laravel specific deployment options for Capistrano 3.x"
  spec.description   = "Laravel deployment for Capistrano 3.x"
  spec.homepage      = "https://github.com/capistrano/laravel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.0"

  spec.add_dependency "capistrano", ">= 3.0.0"
  spec.add_dependency "capistrano-composer", ">= 0.0.6"
  spec.add_dependency "capistrano-file-permissions", ">= 1.0.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 10.0.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
end
