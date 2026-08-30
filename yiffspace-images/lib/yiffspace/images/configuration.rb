# frozen_string_literal: true

module YiffSpace
  module Images
    class Configuration
      attr_accessor(:server_url, :update_token, :default_avatar_type, :default_banner_type, :httparty_options)

      def initialize
        @server_url          = "https://images.yiff.space"
        @default_avatar_type = :discord
        @default_banner_type = :discord
        @httparty_options    = {
          timeout:      10,
          open_timeout: 5,
          headers:      {
            "User-Agent" => "YiffSpaceRuby/#{YiffSpace::Images::VERSION} (https://yiff.space)",
          },
        }
      end
    end
  end
end
