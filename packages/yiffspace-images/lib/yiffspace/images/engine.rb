# frozen_string_literal: true

require("rails")

module YiffSpace
  module Images
    # No app/ of its own - this exists to register the Avatar/BannerSerializer with ActiveJob.
    class Engine < ::Rails::Engine
      config.root = File.expand_path("../../..", __dir__)

      initializer("yiffspace.images.serializers") do
        ActiveSupport.on_load(:active_job) do
          ActiveJob::Serializers.add_serializers(
            Serializers::AvatarSerializer,
            Serializers::BannerSerializer,
          )
        end
      end
    end
  end
end
