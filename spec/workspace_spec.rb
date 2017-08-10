describe Workspace do
  it "creates a Workspace::Dir" do
    expect(Workspace.dir(".")).to be_a Workspace::Dir
  end

  it "creates a temporary Workspace::Dir for a block" do
    Workspace.tmpdir do |dir|
      expect(dir).to be_a Workspace::Dir
    end
  end

  it "creates a temporary Workspace::Dir without a block" do
    dir = Workspace.tmpdir("sample")
    expect(dir).to be_a Workspace::Dir
    expect(dir.name).to match(/^sample/)
    expect(dir.exists?).to be_truthy
    dir.delete
    expect(dir.exists?).to be_falsy
  end

  it "creates a Workspace::File" do
    expect(Workspace.file("sample.txt")).to be_a Workspace::File
  end
end
