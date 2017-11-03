require "workspace-parse"

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }

  it "reads a json file" do
    json_data = { "foo" => "bar" }
    json_file = root.file("sample.json").write(JSON.dump(json_data))
    expect(json_file.read_json).to eq(json_data)
  end

  it "reads a yaml file" do
    yaml_data = { "foo" => "bar" }
    yaml_file = root.file("sample.yaml").write(Psych.dump(yaml_data))
    expect(yaml_file.read_yaml).to eq(yaml_data)
  end

  it "reads a haml file" do
    haml_data = ".main"
    haml_file = root.file("sample.haml").write(haml_data)
    expect(haml_file.read_haml).to eq("<div class='main'></div>\n")
  end

  it "reads a erb file" do
    erb_data = "<title><%= title %></title>"
    erb_file = root.file("sample.erb").write(erb_data)
    expect(erb_file.read_erb({ title: "test" })).to eq("<title>test</title>")
  end
end
