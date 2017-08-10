module Workspace
  class Dir
    attr_accessor :workspace, :path

    def ==(other)
      other.class == self.class && other.to_s == self.to_s
    end

    def initialize(workspace, path = "/")
      @workspace = workspace
      @path = path
    end

    def to_s
      ::File.join(@workspace, @path)
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
      to_s
    end

    def name
      ::File.basename(to_s)
    end

    def create
      FileUtils.mkdir_p(to_s)
      self
    end

    def exists?
      ::File.directory?(to_s)
    end

    def empty?
      !exists? or children.count == 0
    end

    def copy(target_dir)
      target_dir.parent_dir.create unless target_dir.parent_dir.exists?
      FileUtils.cp_r(to_s, target_dir.to_s)
      self
    end

    def move(target_dir)
      target_dir.parent_dir.create unless target_dir.parent_dir.exists?
      FileUtils.mv(to_s, target_dir.to_s)
      self
    end

    def delete
      FileUtils.rm_rf(to_s)
    end

    def clean
      delete
      create
    end

    def file(file_path)
      Workspace::File.new(@workspace, ::File.join(@path, file_path))
    end

    def dir(dir_path)
      Workspace::Dir.new(@workspace, ::File.join(@path, dir_path))
    end

    def root_dir
      Workspace::Dir.new(@workspace, "")
    end

    def parent_dir
      root_dir.dir(::File.expand_path("..", @path))
    end

    def children(glob = "*", &block)
      entries = []
      ::Dir.chdir(to_s) do
        ::Dir[glob].each do |path|
          entry = ::File.directory?(::File.join(to_s, path)) ? dir(path) : file(path)
          yield entry if block_given?
          entries.push(entry)
        end
      end
      entries
    end

    def files(&block)
      children("*.*", &block)
    end

    def directories(&block)
      children("*/", &block)
    end
  end
end
