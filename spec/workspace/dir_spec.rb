describe Workspace::Dir do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  let(:root_with_contents) do
    result = Workspace.tmpdir("workspace-spec")
    result.dir("folder1").create
    result.dir("folder2").create
    result.dir("folder2").file("file1.txt").write("file1")
    result.dir("folder2").file("file2.txt").write("file2")
    result.file("file1.txt").write("file1")
    result.file("file2.txt").write("file2")
    result
  end

  it "casts to string" do
    expect(root.to_s).to match("workspace-spec")
  end

  it "returns a relative path" do
    path = root.dir("subdir1").relative_path(root.dir("subdir2"))
    expect(path).to eq("../subdir1")
    expect(root.dir("subdir1").relative_path).to eq("subdir1")
  end

  it "returns an absolute path" do
    expect(root.absolute_path).to match("workspace-spec")
  end

  it "returns a name" do
    expect(root.dir("source").name).to eq("source")
  end

  it "creates a sub-directory" do
    source = root.dir("source").create
    expect(source.exists?).to be_truthy
  end

  it "checks for existance" do
    source = root.dir("source")
    expect(source.exists?).to be_falsy
    source.create
    expect(source.exists?).to be_truthy
    source.delete
    expect(source.exists?).to be_falsy
  end

  it "checks if a folder is empty" do
    source = root.dir("source").create
    expect(source.empty?).to be_truthy
    source.file("foobar.txt").write("helloworld")
    expect(source.empty?).to be_falsy
  end

  it "copies to another folder" do
    source = root.dir("source").create
    target = root.dir("target")
    source.copy(target)
    expect(target.exists?).to be_truthy
  end

  it "moves to another folder" do
    source = root.dir("source").create
    target = root.dir("target")
    source.move(target)
    expect(target.exists?).to be_truthy
    expect(source.exists?).to be_falsy
  end

  it "deletes a folder" do
    source = root.dir("source").create
    expect(source.exists?).to be_truthy
    source.delete
    expect(source.exists?).to be_falsy
  end

  it "cleans a folder" do
    source = root.dir("source").create
    source.file("foobar.txt").write("helloworld")
    expect(source.empty?).to be_falsy
    source.clean
    expect(source.empty?).to be_truthy
  end

  it "instantiates a file" do
    expect(root.file("sample")).to be_a Workspace::File
  end

  it "instantiates a directory" do
    expect(root.dir("sample")).to be_a Workspace::Dir
  end

  it "returns the root dir" do
    expect(root.dir("sample").dir("sample").root_dir).to eq(root)
  end

  it "returns the parent dir" do
    expect(root.dir("sample").parent_dir).to eq(root)
  end

  it "returns a list of children" do
    expect(root_with_contents.children.count).to eq 4
    expect(root_with_contents.children("*/").count).to eq 2
    expect(root_with_contents.children("*.txt").count).to eq 2
    expect(root_with_contents.children("**/*.txt").count).to eq 4
  end

  it "traverses through children" do
    expect { |b| root_with_contents.children("*", &b) }.to yield_control.exactly(4).times
    expect { |b| root_with_contents.children("*/", &b) }.to yield_control.exactly(2).times
    expect { |b| root_with_contents.children("*.txt", &b) }.to yield_control.exactly(2).times
    expect { |b| root_with_contents.children("**/*.txt", &b) }.to yield_control.exactly(4).times
  end

  it "traverses through files" do
    expect { |b| root_with_contents.files(&b) }.to yield_control.exactly(2).times
  end

  it "traverses through directories" do
    expect { |b| root_with_contents.directories(&b) }.to yield_control.exactly(2).times
  end
end
