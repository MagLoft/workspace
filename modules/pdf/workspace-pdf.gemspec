lib = File.expand_path(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "workspace/version"

Gem::Specification.new do |s|
  s.name        = "workspace-pdf"
  s.version     = Workspace::VERSION
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["tobias.strebitzer@magloft.com"]
  s.homepage    = "https://github.com/magloft/workspace"
  s.summary     = "Workspace gem extension to allow transformation and optimization of pdf files"
  s.description = "Workspace makes it a breeze to work with files and directories"
  s.required_ruby_version = '>= 2.4'
  s.add_runtime_dependency "poppler", "~> 3.3"
  s.add_runtime_dependency "workspace", "~> 2.0"
  s.files        = ["workspace-pdf.rb"]
  s.require_path = '.'
end
