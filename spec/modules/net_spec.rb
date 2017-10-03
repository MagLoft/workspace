require "workspace-net"

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  let(:local_file) { Workspace::Dir.new(Dir.pwd).file("README.md") }
  let(:remote_url) { "//github.com/MagLoft/workspace/raw/master/README.md" }
  let(:remote_url_http) { "http:#{remote_url}" }
  let(:remote_url_https) { "https:#{remote_url}" }

  before do
    Typhoeus.stub(/github\.com/).and_return(Typhoeus::Response.new(code: 200, body: local_file.read))
  end

  it "downloads a file from a remote server" do
    expect(root.file("README.md").download(remote_url).read).to eq(local_file.read)
    expect(root.file("README.md").download(remote_url_http).read).to eq(local_file.read)
    expect(root.file("README.md").download(remote_url_https).read).to eq(local_file.read)
  end

  it "downloads multiple files anynchronously" do
    hydra = Typhoeus::Hydra.new(max_concurrency: 3)
    hydra.queue(root.file("file1.txt").queue_download(remote_url))
    hydra.queue(root.file("file2.txt").queue_download(remote_url))
    hydra.queue(root.file("file3.txt").queue_download(remote_url))
    hydra.run
    expect(root.children.count).to eq 3
    root.children.each do |file|
      expect(file.read).to eq(local_file.read)
    end
  end
end
