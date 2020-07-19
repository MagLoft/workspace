lib = File.expand_path('lib', __dir__)
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
  s.required_ruby_version = '>= 2.4'
  s.add_dependency "bundler", "< 3.0.0", ">= 1.12.0"
  s.add_runtime_dependency "mime-types", "~> 3.2"
  s.add_development_dependency "pry", "~> 0.12"
  s.add_development_dependency "rspec", "~> 3.8"
  s.add_development_dependency "rubocop", "~> 0.69"
  s.add_development_dependency "simplecov", "~> 0.16"
  s.add_development_dependency "simplecov-console", "~> 0.4"
  s.files        = Dir["README.md", "lib/**/*"]
  s.require_path = 'lib'
end
