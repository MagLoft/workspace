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
      { width: image.columns, height: image.rows }
    ensure image&.destroy!
    end

    def fit(width: nil, height: nil, quality: 85)
      image = Magick::Image.read(to_s).first
      width = [image.columns, image.rows].min if width.nil? and height.nil?
      width = image.columns if width.nil?
      height = width if height.nil?
      image.change_geometry!("#{width}x^#{height}") { |cols, rows| image.thumbnail!(cols, rows) }
      image.crop!(0, 0, width, height)
      image.write(to_s) { self.quality = quality }
      self
    ensure image&.destroy!
    end

    def optimize!(image_max_width: nil, quality: 85, convert_jpg: true, optimize: true)
      return false if !exists? or !image?
      image = Magick::Image.read(to_s).first
      if !image_max_width.nil? and image.columns > image_max_width
        image.change_geometry!("#{image_max_width}>x") { |cols, rows, img| img.resize!(cols, rows) }
      end
      if mimetype == "image/png" and convert_jpg and (!image.alpha? or image.resize(1, 1).pixel_color(0, 0).opacity == 0)
        image.format = "JPG"
        rename("#{basename}.jpg")
      end
      image.write(to_s) { self.quality = quality }
      Piet.optimize(to_s, verbose: false) if optimize
      self
    ensure image&.destroy!
    end
  end
end
