# frozen_string_literal: true

require("rails")

module YiffSpace
  class Engine < ::Rails::Engine
    config.root = File.expand_path("../..", __dir__)

    initializer("yiffspace.assets") do |app|
      app.config.assets.precompile += %w[yiffspace/application.css] if app.config.respond_to?(:assets)
    end

    initializer("yiffspace.serializers") do
      ActiveSupport.on_load(:active_job) do
        ActiveJob::Serializers.add_serializers(
          Serializers::AvatarSerializer,
          Serializers::BannerSerializer,
          Serializers::UserResolvableSerializer,
        )
      end
    end
  end
end
