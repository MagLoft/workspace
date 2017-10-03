require "typhoeus"

module Workspace
  class File
    def download(url, followlocation: true, verify: false)
      dir.create unless dir.exists?
      queue_download(url, followlocation: followlocation, verify: verify).run
      self
    end

    def queue_download(url, followlocation: true, verify: false, &block)
      uri = URI(url)
      uri.scheme ||= "http"
      request = Typhoeus::Request.new(uri.to_s, followlocation: followlocation, ssl_verifypeer: verify, ssl_verifyhost: (verify ? 2 : 0))
      request.on_complete do |response|
        if response.success?
          write(response.body)
          yield(self) unless block.nil?
        end
      end
      request
    end
  end
end
