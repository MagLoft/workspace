require "haml"
require "erb"
require "ostruct"
require "psych"

module Workspace
  class File
    def read_json
      JSON.parse(read)
    end

    def read_yaml
      Psych.load_file(to_s)
    end

    def read_haml(options = {})
      engine = Haml::Engine.new(read)
      engine.render(Object.new, options)
    end

    def read_erb(options = {})
      ERB.new(::File.read(to_s)).result(OpenStruct.new(options).instance_eval { binding })
    end
  end
end
