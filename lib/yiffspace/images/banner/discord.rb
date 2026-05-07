# frozen_string_literal: true

require("httparty")

module YiffSpace
  module Images
    module Banner
      class Discord < Base
        def self.type = :discord

        def initialize(id)
          super(id, self.class.type)
        end

        def url
          "#{YiffSpace.config.images.server_url}/banner/discord/#{id}"
        end

        def update(hash)
          raise(StandardError, "images.update_token config option must be set to use banner update") if YiffSpace.config.images.update_token.blank?
          response = HTTParty.post("#{YiffSpace.config.images.server_url}/banner/discord/update/#{id}",
                                   YiffSpace.config.images.httparty_options.deep_merge(
                                     headers: {
                                       "Authorization" => "Bearer #{YiffSpace.config.images.update_token}",
                                       "Content-Type"  => "application/json",
                                     },
                                     body:    { hash: hash }.to_json,
                                   ))
          unless response.key?("updated")
            Rails.logger.error("banner update failed: #{response.to_json}")
          end

          response.fetch("updated", false)
        end
      end
    end
  end
end
