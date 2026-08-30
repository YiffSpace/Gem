# frozen_string_literal: true

require("rails")

module YiffSpace
  module User
    # No app/ of its own - this exists to register the UserResolvableSerializer with ActiveJob.
    class Engine < ::Rails::Engine
      config.root = File.expand_path("../../..", __dir__)

      initializer("yiffspace.user.serializers") do
        ActiveSupport.on_load(:active_job) do
          ActiveJob::Serializers.add_serializers(Serializers::UserResolvableSerializer)
        end
      end
    end
  end
end
