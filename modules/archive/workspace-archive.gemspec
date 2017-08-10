lib = File.expand_path('.', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "workspace-archive"
  s.version     = "1.0.0"
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["tobias.strebitzer@magloft.com"]
  s.homepage    = "https://github.com/magloft/workspace"
  s.summary     = "Workspace gem extension to allow compression and extraction of zip and gz archives"
  s.description = "Workspace makes it a breeze to work with files and directories"
  s.required_ruby_version = '~> 2.0'
  s.required_rubygems_version = '~> 2.4'
  s.add_runtime_dependency "workspace", "~> 1.0"
  s.add_runtime_dependency "rubyzip", "~> 1.2"
  s.files        = ["workspace-archive.rb"]
  s.require_path = '.'
end
