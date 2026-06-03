# frozen_string_literal: true

module YiffSpace
  class Railtie < Rails::Railtie
    initializer("yiffspace.serializers") do
      ActiveSupport.on_load(:active_job) do
        ActiveJob::Serializers.add_serializers(
          Serializers::AnonymousAuthInfoSerializer,
          Serializers::AnonymousUserInfoSerializer,
          Serializers::AuthInfoSerializer,
          Serializers::AvatarSerializer,
          Serializers::BannerSerializer,
          Serializers::DiscordInfoSerializer,
          Serializers::PermissionsSerializer,
          Serializers::UserInfoSerializer,
          Serializers::UserResolvableSerializer,
        )
      end
    end
  end
end
