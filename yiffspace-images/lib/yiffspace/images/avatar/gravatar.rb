# frozen_string_literal: true

require("httparty")

module YiffSpace
  module Images
    module Avatar
      class Gravatar < Base
        def self.type = :gravatar

        def initialize(id)
          super(id, self.class.type)
        end

        def url
          "#{YiffSpace.config.images.server_url}/avatar/gravatar/#{id}"
        end
      end
    end
  end
end
