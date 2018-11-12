require "workspace-archive"

describe Workspace::Dir do
  let(:root) { Workspace.tmpdir("workspace-spec") }

  it "compresses a directory to zip" do
    root.dir("dir").create.file("file.txt").write("hello world")
    root.dir("dir").compress(root.file("dir.zip"))
    expect(root.file("dir.zip").exists?).to eq(true)
  end

  it "compresses a directory to tar.gz" do
    root.dir("dir").create.file("file.txt").write("hello world")
    root.dir("dir").dir("subdir").create.file("file.txt").write("hello world")
    root.dir("dir").compress(root.file("dir.tar.gz"))
    expect(root.file("dir.tar.gz").exists?).to eq(true)
  end

  it "compresses a directory using blocks" do
    root.dir("dir").create.file("file1.txt").write("hello world")
    root.dir("dir").create.file("file2.txt").write("hello world")
    root.dir("dir").compress(root.file("dir.zip")) do |path|
      path != "file1.txt"
    end
    expect(root.file("dir.zip").exists?).to eq(true)
    root.file("dir.zip").extract(root.dir("output"))
    expect(root.dir("output").files.length).to eq 1
  end
end

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }

  it "compresses a file" do
    root.file("file.txt").write("hello world").compress(root.file("file.zip"))
    expect(root.file("file.zip").exists?).to eq(true)
  end

  it "extracts a zip file" do
    root.file("file.txt").write("hello world").compress(root.file("file.zip"))
    root.file("file.zip").extract(root.dir("output"))
    expect(root.dir("output").file("file.txt").read).to eq("hello world")
  end

  it "compresses and extracts a file without extension" do
    root.file("FOOBAR").write("hello world").compress(root.file("file.zip"))
    root.file("file.zip").extract(root.dir("output"))
    expect(root.dir("output").file("FOOBAR").read).to eq("hello world")
  end

  it "compresses and extracts a file with dot-prefix" do
    root.file(".FOOBAR").write("hello world").compress(root.file("file.zip"))
    root.file("file.zip").extract(root.dir("output"))
    expect(root.dir("output").file(".FOOBAR").read).to eq("hello world")
  end

  it "extracts a directory from tar.gz" do
    root.dir("dir").create.file("file.txt").write("hello world")
    root.dir("dir").dir("subdir").create.file("file.txt").write("hello world")
    root.dir("dir").compress(root.file("dir.tar.gz"))
    root.file("dir.tar.gz").extract(root.dir("output"))
    expect(root.dir("output").dir("dir").file("file.txt").read).to eq("hello world")
  end
end
