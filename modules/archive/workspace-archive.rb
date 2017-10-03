require "zip"
require 'rubygems/package'

module Workspace
  class Dir
    def compress(target_file)
      target_file.delete
      if target_file.extension == "gz"
        compress_gz(target_file)
      else
        compress_zip(target_file)
      end
      self
    end

    private

    def compress_gz(target_file)
      ::File.open(target_file.to_s, "wb") do |gzfile|
        Zlib::GzipWriter.wrap(gzfile) do |gz|
          Gem::Package::TarWriter.new(gz) do |tar|
            children("**/*") do |child|
              mode = ::File.stat(child.to_s).mode
              if child.kind_of?(File)
                tar.add_file_simple(child.relative_path, mode, child.read.length) do |io|
                  io.write(child.read)
                end
              elsif child.kind_of?(Dir)
                tar.mkdir(child.relative_path, mode)
              end
            end
          end
        end
      end
      target_file
    end

    def compress_zip(target_file)
      Zip::File.open(target_file.to_s, 'w') do |zipfile|
        ::Dir["#{self}/**/**"].each do |file|
          path = file.sub("#{self}/", '')
          zipfile.add(path, file) unless block_given? and !yield(path)
        end
      end
    end
  end

  class File
    def compress(target_file)
      target_file.delete
      Zip::File.open(target_file.to_s, 'w') do |zipfile|
        zipfile.add(name, absolute_path)
      end
      self
    end

    def extract(target_dir)
      target_dir.create
      if extension == "gz"
        extract_gz(target_dir)
      else
        extract_zip(target_dir)
      end
      self
    end

    private

    def extract_zip(target_dir)
      Zip::File.open(to_s) do |archive|
        archive.each do |entry|
          entry_name = entry.name.force_encoding("UTF-8")
          extract_dir = target_dir.file(entry_name).dir
          extract_dir.create unless extract_dir.exists?
          entry.extract(::File.join(target_dir.to_s, entry_name))
        end
      end
    end

    def extract_gz(target_dir)
      archive = Gem::Package::TarReader.new(Zlib::GzipReader.open(to_s))
      archive.rewind
      archive.each do |entry|
        if entry.directory?
          archive_dir = target_dir.dir(entry.full_name)
          archive_dir.create
        elsif entry.file?
          archive_file = target_dir.file(entry.full_name)
          archive_file.write(entry.read)
        end
      end
      archive.close
    end
  end
end
