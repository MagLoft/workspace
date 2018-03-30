require "workspace-pdf"

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  let(:fixtures) { Workspace.dir("spec/fixtures") }
  let(:output_dir) { root.dir("output").create }

  it "detects a pdf file" do
    expect(fixtures.file("sample.pdf").pdf?).to be_truthy
  end

  it "reads a pdf file" do
    pdf = fixtures.file("sample.pdf").pdf
    expect(pdf.size).to eq(3)
    page = pdf.pages.first
    expect(page.number).to eq(1)
    expect(page.title).to eq("Page 1")
    expect(page.width).to eq(684.0)
    expect(page.height).to eq(864.0)
    expect(page.ratio).to eq(684.0 / 864.0)
    pdf.export(output_dir, width: 2048)
    expect(output_dir.files.count).to eq 3
  end
end
