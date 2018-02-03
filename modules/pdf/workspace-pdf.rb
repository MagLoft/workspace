require "poppler"

module Workspace
  class File
    def pdf?
      ["pdf"].include?(extension)
    end

    def pdf
      Pdf.new(self)
    end

    class Pdf
      attr_reader :file, :document, :pages

      def initialize(file)
        @file = file
        @document = Poppler::Document.new(@file.to_s)
        @pages = @document.pages.map { |page| PdfPage.new(self, page) }
      end

      def export(output_dir, filename: 'page-%03d.png', width: nil, &block)
        pages.each do |page|
          page.export(output_dir.file(filename % page.index), { width: width }, &block)
        end
      end

      def size
        document.size
      end
    end

    class PdfPage
      attr_reader :pdf, :page

      def initialize(pdf, page)
        @pdf = pdf
        @page = page
      end

      def index
        page.index
      end

      def number
        page.index + 1
      end

      def title
        "Page #{number}"
      end

      def width
        page.size[0]
      end

      def height
        page.size[1]
      end

      def ratio
        width / height
      end

      def export(output_file, width: nil, &block)
        output_width = @page.size[0]
        output_height = @page.size[1]
        output_scale = 1.0
        unless width.nil?
          output_scale = width / output_width
          output_width *= output_scale
          output_height *= output_scale
        end
        surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, output_width, output_height)
        context = Cairo::Context.new(surface)
        context.set_source_rgb(1, 1, 1)
        context.paint
        context.scale(output_scale, output_scale)
        context.render_poppler_page(@page)
        yield(context) if block_given?
        output_file.dir.create unless output_file.dir.exists?
        surface.write_to_png(output_file.to_s)
        context.target.finish
      end
    end
  end
end
