# frozen_string_literal: true

module YiffSpace
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace(YiffSpace::Auth)
      config.root = File.expand_path("../../../engines/auth", __dir__)
      shared_root = File.expand_path("../../../app", __dir__)
      shared_controllers = "#{shared_root}/controllers"
      shared_helpers = "#{shared_root}/helpers"
      shared_models = "#{shared_root}/models"
      shared_views = "#{shared_root}/views"
      shared_assets = "#{shared_root}/assets"

      paths["app/controllers"] << shared_controllers
      paths["app/helpers"] << shared_helpers
      paths["app/models"] << shared_models
      paths["app/views"] << shared_views
      paths["app/assets"] << shared_assets

      config.autoload_paths += [shared_controllers, shared_helpers, shared_models]
      config.eager_load_paths += [shared_controllers, shared_helpers, shared_models]

      initializer("yiff_space.auth.asset_paths") do |app|
        app.config.assets.paths << "#{shared_assets}/config"
      end
    end
  end
end
