# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Auth
    class SessionSerializationTest < ActiveSupport::TestCase
      test("auth info round-trips through session data") do
        token = build_token
        auth = AuthInfo.new(
          id:           "123",
          token:        token,
          entitlements: %w[posts.read admin.users.read],
          roles:        %w[staff],
        )

        restored = with_stubbed_client(Struct.new(:identifier).new("client-123")) do
          AuthInfo.from_session(auth.to_session)
        end

        assert_equal("123", restored.id)
        assert_instance_of(OpenIDConnect::AccessToken, restored.token)
        assert_equal(%w[posts.read admin.users.read], restored.entitlements)
        assert_equal(%w[staff], restored.roles)
      end

      test("auth info serializes token into session data") do
        auth = AuthInfo.new(
          id:           "123",
          token:        build_token,
          entitlements: %w[posts.read admin.users.read],
          roles:        %w[staff],
        )

        data = auth.to_session

        assert_equal("123", data["id"])
        assert_equal(%w[posts.read admin.users.read], data["entitlements"])
        assert_equal(%w[staff], data["roles"])
        assert(data.key?("token"), "expected session data to include serialized token")
      end

      test("user info round-trips through session data") do
        user = UserInfo.new(
          id:        "123",
          user:      build_user,
          client_id: "client-123",
          discord:   {
            "id"            => "123",
            "avatar"        => "abc",
            "username"      => "fox",
            "avatar_url"    => "https://cdn.example.com/avatar.png",
            "discriminator" => "0001",
          },
        )

        restored = with_stubbed_client(Struct.new(:identifier).new("client-123")) do
          UserInfo.from_session(user.to_session)
        end

        assert_equal("123", restored.id)
        assert_equal("fox", restored.discord.username)
        assert_equal("123", restored.user.sub)
      end

      test("user info rebuilds from session data") do
        user = UserInfo.new(
          id:        "123",
          user:      build_user,
          client_id: "client-123",
          discord:   {
            "id"            => "123",
            "avatar"        => "abc",
            "username"      => "fox",
            "avatar_url"    => "https://cdn.example.com/avatar.png",
            "discriminator" => "0001",
          },
        )

        restored = with_stubbed_client(Struct.new(:identifier).new("client-123")) do
          UserInfo.from_session(user.to_session)
        end

        assert_equal("123", restored.id)
        assert_equal("fox", restored.discord.username)
        assert_equal("123", restored.user.sub)
      end

      private

      def build_token
        OpenIDConnect::AccessToken.new(
          access_token: "secret",
          token_type:   "Bearer",
          expires_in:   3600,
          client:       Struct.new(:identifier).new("client-123"),
        )
      end

      def build_user
        OpenIDConnect::ResponseObject::UserInfo.new(
          "sub"   => "123",
          "email" => "fox@example.com",
        )
      end

      def with_stubbed_client(oidc_client)
        clients = YiffSpace::Auth.instance_variable_get(:@clients)
        stub_config = Object.new
        stub_config.define_singleton_method(:oidc_client) { oidc_client }
        clients[:_stub] = stub_config
        yield
      ensure
        clients.delete(:_stub)
      end
    end
  end
end