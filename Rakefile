require "workspace"
require "workspace/version"
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
version = Workspace::VERSION

def run_command(cmd, dir)
  Dir.chdir(dir.to_s) do
    `#{cmd}`
  end
end

task default: [:rubocop, :spec] do
  root = Workspace::Dir.new(Dir.pwd)

  # build main gem
  puts "- building workspace gem"
  run_command("bundle install", root)
  run_command("gem build workspace.gemspec", root)

  # build modules
  root.dir("modules").children.each do |module_dir|
    puts "- building module #{module_dir.name}"
    run_command("bundle install", module_dir)
    run_command("gem build workspace-#{module_dir.name}.gemspec", module_dir)
  end
end

task deploy: [:default] do
  root = Workspace::Dir.new(Dir.pwd)
  files = [root.file("workspace-#{version}.gem"), *root.dir("modules").children.map do |module_dir|
    module_dir.file("workspace-#{module_dir.name}-#{version}.gem")
  end]
  abort "ERROR: Gem files are missing!" if files.any? { |f| !f.exists? }
  files.each do |file|
    run_command("gem push #{file.name}", file.dir)
  end
end
