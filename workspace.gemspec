lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workspace/version'

Gem::Specification.new do |s|
  s.name        = "workspace"
  s.version     = Workspace::VERSION
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["tobias.strebitzer@magloft.com"]
  s.homepage    = "https://github.com/magloft/workspace"
  s.summary     = "Simplified Files and Directories handling"
  s.description = "Workspace makes it a breeze to work with files and directories"
  s.required_ruby_version = '~> 2.0'
  s.required_rubygems_version = '~> 2.4'
  s.add_dependency "bundler", '>= 1.3.0', '< 2.0'
  s.add_runtime_dependency "mime-types", "~> 3.1"
  s.add_development_dependency "rspec", "~> 3.6"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "rubocop", "~> 0.49"
  s.add_development_dependency "simplecov", "~> 0.10"
  s.add_development_dependency "simplecov-console", "~> 0.4"
  s.files        = Dir["README.md", "lib/**/*"]
  s.require_path = 'lib'
end
