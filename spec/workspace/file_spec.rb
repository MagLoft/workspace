describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  let(:file) { root.file("sample.txt").write("hello world") }

  it "casts to string" do
    expect(file.to_s).to match("sample.txt$")
  end

  it "returns a name" do
    expect(file.name).to eq("sample.txt")
  end

  it "returns an basename" do
    expect(file.basename).to eq("sample")
  end

  it "returns an extension" do
    expect(file.extension).to eq("txt")
  end

  it "returns an mimetype" do
    expect(file.mimetype).to eq("text/plain")
  end

  it "returns a relative path" do
    relative_dir = root.dir("subdir").create
    expect(file.relative_path(relative_dir)).to eq("../sample.txt")
    file2 = relative_dir.file("sample.txt")
    expect(file2.relative_path).to eq("subdir/sample.txt")
  end

  it "returns an absolute path" do
    expect(file.absolute_path).to match("workspace-spec")
  end

  it "returns its directory" do
    expect(file.dir).to eq(root)
  end

  it "checks for existance" do
    source = root.file("foobar.txt")
    expect(source.exists?).to be_falsy
    source.write("sample")
    expect(source.exists?).to be_truthy
  end

  it "reads a file" do
    expect(file.read).to eq("hello world")
  end

  it "sets contents without writing" do
    file.set("hello bar")
    expect(file.read).to eq("hello bar")
    expect(root.file("sample.txt").read).to eq("hello world")
  end

  it "replaces contents" do
    file.replace("world", "bar")
    expect(file.read).to eq("hello bar")
  end

  it "writes a file" do
    file.write("hello bar")
    expect(file.read).to eq("hello bar")
  end

  it "copies a file" do
    result = root.file("result.txt")
    file.copy(result)
    expect(result.exists?).to be_truthy
    expect(file.read).to eq(result.read)
  end

  it "renames to another name" do
    file.rename("foobar.txt")
    expect(root.file("foobar.txt").exists?).to be_truthy
    expect(root.file("foobar.txt").read).to eq("hello world")
  end

  it "moves a file to another file" do
    target_file = root.file("foobar.txt")
    file.move(target_file)
    expect(target_file.exists?).to be_truthy
    expect(target_file.read).to eq("hello world")
  end

  it "deletes a file" do
    file.delete
    expect(file.exists?).to be_falsy
  end

  it "streams a file for writing" do
    file.stream("wb") do |io|
      io.write("hello")
      io.write("world")
    end
    expect(file.read).to eq("helloworld")
  end

  it "streams a file for reading" do
    file.write("hello\nworld\n")
    file.stream("r") do |io|
      expect(io.readline).to eq("hello\n")
      expect(io.readline).to eq("world\n")
    end
  end
end
