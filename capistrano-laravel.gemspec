# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-laravel'
  spec.version       = '0.0.3'
  spec.authors       = ['Peter Mitchell']
  spec.email         = ['peterjmit@gmail.com']
  spec.description   = %q{Laravel specific deployment options for Capistrano 3.x}
  spec.summary       = %q{Laravel deployment for Capistrano 3.x}
  spec.homepage      = 'https://github.com/peterjmit/capistrano-laravel'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.0'
  spec.add_dependency 'capistrano-composer', '~> 0.0.3'
  spec.add_dependency 'capistrano-file-permissions', '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.4'
end
