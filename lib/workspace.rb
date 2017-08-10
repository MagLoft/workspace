require "workspace/dir"
require "workspace/file"

module Workspace
  def self.dir(path = "/")
    Workspace::Dir.new(path)
  end

  def self.tmpdir(path = nil, &block)
    if block.nil?
      dir(::Dir.mktmpdir(path))
    else
      ::Dir.mktmpdir(path) do |tmppath|
        yield(dir(tmppath))
      end
    end
  end

  def self.file(path, workspace: ".")
    Workspace::File.new(workspace, path)
  end
end
