require "workspace-pdf"

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  let(:fixtures) { Workspace.dir("spec/fixtures") }
  let(:output_dir) { root.dir("output").create }

  it "detects a pdf file" do
    expect(fixtures.file("sample.pdf").pdf?).to be_truthy
  end

  it "reads a pdf file" do
    fixtures.file("sample.pdf").pdf.export(output_dir, width: 2048)
    expect(output_dir.files.count).to eq 3
  end
end
