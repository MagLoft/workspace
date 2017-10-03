require "mime/types"

module Workspace
  class File
    attr_accessor :workspace, :path

    def initialize(workspace, path)
      @workspace = workspace
      @path = path
    end

    def to_s
      ::File.join(@workspace, @path)
    end

    def name
      "#{basename}.#{extension}"
    end

    def basename
      ::File.basename(path, ".*")
    end

    def extension
      ::File.extname(to_s).gsub(/^\./, "")
    end

    def mimetype
      type = MIME::Types.of(name).first
      type ? type.to_s : nil
    end

    def relative_path(relative_dir = nil)
      if relative_dir
        relative_dir = relative_dir.dir if relative_dir.class == Workspace::File
        first = Pathname.new(relative_dir.path)
        second = Pathname.new(path)
        result = second.relative_path_from(first).to_s
        result
      else
        @path.gsub(%r{^/}, "")
      end
    end

    def absolute_path
      ::File.absolute_path(to_s)
    end

    def dir
      Workspace::Dir.new(@workspace, ::File.dirname(@path))
    end

    def exists?
      ::File.exist?(to_s)
    end

    def read
      @contents ||= ::File.open(to_s).read
    end

    def set(data)
      @contents = data
      self
    end

    def replace(key, value)
      read.gsub!(key, value)
      self
    end

    def write(data = nil)
      data ||= @contents
      dir.create unless dir.exists?
      ::File.open(to_s, "wb") { |file| file << data }
      self
    end

    def copy(target_file)
      target_file.dir.create unless target_file.dir.exists?
      FileUtils.cp(to_s, target_file.to_s)
    end

    def rename(filename)
      FileUtils.mv(to_s, dir.file(filename).to_s) if exists?
      @path = dir.file(filename).path
    end

    def move(target_file)
      target_file.dir.create unless target_file.dir.exists?
      FileUtils.mv(to_s, target_file.to_s)
      target_file
    end

    def delete
      FileUtils.rm_f(to_s)
    end
  end
end
