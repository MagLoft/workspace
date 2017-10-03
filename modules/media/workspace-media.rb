require "piet"
require "rmagick"

module Workspace
  class File
    def image?
      ["jpg", "jpeg", "gif", "png"].include?(extension)
    end

    def video?
      ["mp4"].include?(extension)
    end

    def audio?
      ["mp3"].include?(extension)
    end

    def image_size
      image = Magick::Image.read(to_s).first
      size = { width: image.columns, height: image.rows }
      image.destroy!
      size
    end

    def fit(width: nil, height: nil, quality: 85)
      image = Magick::Image.read(to_s).first
      width = [image.columns, image.rows].min if width.nil? and height.nil?
      width = image.columns if width.nil?
      height = width if height.nil?
      image.change_geometry!("#{width}x^#{height}") { |cols, rows| image.thumbnail!(cols, rows) }
      image.crop!(0, 0, width, height)
      image.write(to_s) { self.quality = quality }
      image.destroy!
      self
    end

    def optimize!(options = {})
      return false if !exists? or !image?
      optimize_png!(options) if ["png"].include?(extension)
      optimize_jpg!(options) if ["jpg", "jpeg"].include?(extension)
      Piet.optimize(to_s, verbose: false)
      self
    end

    private

    def optimize_jpg!(image_max_width: 2048, quality: 85)
      image = Magick::Image.read(to_s).first
      image.change_geometry!("#{image_max_width}>x") { |cols, rows, img| img.resize!(cols, rows) } if image.columns > image_max_width
      image.write(to_s) { self.quality = quality }
      image.destroy!
    end

    def optimize_png!(image_max_width: 2048, quality: 85)
      image = Magick::Image.read(to_s).first
      image.change_geometry!("#{image_max_width}>x") { |cols, rows, img| img.resize!(cols, rows) } if image.columns > image_max_width
      if !image.alpha? or image.resize(1, 1).pixel_color(0, 0).opacity == 0
        image.format = "JPG"
        rename("#{basename}.jpg")
      end
      image.write(to_s) { self.quality = quality }
      image.destroy!
    end
  end
end
