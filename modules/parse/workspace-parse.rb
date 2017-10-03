require "haml"
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
  end
end
