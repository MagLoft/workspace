require "workspace-media"

describe Workspace::File do
  let(:root) { Workspace.tmpdir("workspace-spec") }
  def image
    image = Magick::Image.new(640, 480) { self.background_color = "gray" }
    circle = Magick::Draw.new
    circle.stroke('#FFFFFF')
    circle.fill('#FFFFFF')
    circle.fill_opacity(0.25)
    circle.stroke_opacity(0.75)
    circle.stroke_width(64)
    circle.stroke_linecap('round')
    circle.stroke_linejoin('round')
    circle.circle(image.columns / 2, image.rows / 2, 200, image.rows / 2)
    circle.draw(image)
    image
  end

  def image_file(extension = :jpg)
    file = root.file("image-#{SecureRandom.hex}.#{extension}")
    img = image.write(file.to_s)
    img.destroy!
    file
  end

  it "detects media file types" do
    expect(root.file("foobar.jpg").image?).to be_truthy
    expect(root.file("foobar.jpeg").image?).to be_truthy
    expect(root.file("foobar.gif").image?).to be_truthy
    expect(root.file("foobar.png").image?).to be_truthy
    expect(root.file("foobar.mp4").video?).to be_truthy
    expect(root.file("foobar.mp3").audio?).to be_truthy
  end

  it "reads an image size" do
    expect(image_file(:jpg).image_size).to eq({ width: 640, height: 480 })
  end

  it "fits an image in a a box" do
    expect(image_file(:jpg).fit(width: 200, height: 200).image_size).to eq({ width: 200, height: 200 })
    expect(image_file(:jpg).fit.image_size).to eq({ width: 480, height: 480 })
    expect(image_file(:jpg).fit(width: 128).image_size).to eq({ width: 128, height: 128 })
  end

  it "optimizes an image" do
    expect(image_file(:jpg).optimize!.size).to be < image_file(:jpg).size
    expect(image_file(:png).optimize!.size).to be < image_file(:png).size
  end
end
