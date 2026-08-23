# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Auth
    class SpoofAuthTest < ActiveSupport::TestCase
      TEST_CLIENT_ID = "spoof-test-client-abc123"

      FakeLogtoManagement = Struct.new(:api_user) do
        def get_or_create_user(_id)
          api_user
        end
      end

      class FakeController
        include(Helper)

        attr_accessor(:session)

        def initialize
          @session = {}
          @request_env = {}
        end

        def request
          @request ||= Struct.new(:env).new(@request_env)
        end
      end

      setup do
        api_user_data = {
          "id"           => "logto-spoof-1",
          "name"         => "spoofy",
          "createdAt"    => 0,
          "updatedAt"    => 0,
          "lastSignInAt" => nil,
          "identities"   => {
            "discord" => {
              "userId"  => "999999",
              "details" => {
                "rawData" => { "id" => "999999", "username" => "spoofy", "avatar" => nil, "banner" => nil },
              },
            },
          },
        }
        api_user = ApiUser.new(api_user_data)

        @client = YiffSpace::Auth.register(:_spoof_test) do |c|
          c.client_id = TEST_CLIENT_ID
        end
        @client.define_singleton_method(:logto_management) { FakeLogtoManagement.new(api_user) }

        @controller = FakeController.new
        @controller.request.env[YiffSpace::Auth::CLIENT_NAME_ENV] = :_spoof_test
      end

      teardown do
        YiffSpace::Auth.disable_spoof_auth!
        YiffSpace::Auth.instance_variable_get(:@clients).delete(:_spoof_test)
      end

      test("spoofing is off by default") do
        assert_not(@controller.auth?)
        assert_not(@controller.user?)
        assert_not(@controller.logged_in?)
      end

      test("enabling the global switch without a configured spoof_user_id is a no-op") do
        YiffSpace::Auth.enable_spoof_auth!

        assert_not(@controller.logged_in?)
      end

      test("enabling spoof auth logs the request in as the configured user") do
        @client.spoof_user_id     = "999999"
        @client.spoof_permissions = %w[admin]
        @client.spoof_roles       = %w[staff]
        YiffSpace::Auth.enable_spoof_auth!

        assert(@controller.logged_in?)
        assert_equal("999999", @controller.auth.id)
        assert_equal("999999", @controller.user.id)
        assert_equal(%w[staff], @controller.auth.roles)
        assert(@controller.has_permission?("admin"))
        assert_not(@controller.has_permission?("nope"))
      end

      test("disabling spoof auth reverts the request to anonymous") do
        @client.spoof_user_id = "999999"
        YiffSpace::Auth.enable_spoof_auth!
        assert(@controller.logged_in?)

        YiffSpace::Auth.disable_spoof_auth!

        assert_not(@controller.logged_in?)
      end

      test("a controller can disable spoof auth for its own requests") do
        @client.spoof_user_id = "999999"
        YiffSpace::Auth.enable_spoof_auth!

        @controller.spoof_override = false

        assert_not(@controller.logged_in?)
      end

      test("a controller can override the spoofed permissions and roles") do
        @client.spoof_user_id     = "999999"
        @client.spoof_permissions = %w[admin]
        @client.spoof_roles       = %w[staff]
        YiffSpace::Auth.enable_spoof_auth!

        @controller.spoof_override = { spoof_permissions: %w[owner], spoof_roles: %w[root] }

        assert(@controller.logged_in?)
        assert_equal("999999", @controller.auth.id)
        assert_equal(%w[root], @controller.auth.roles)
        assert(@controller.has_permission?("owner"))
        assert_not(@controller.has_permission?("admin"))
      end

      test("a controller can override the spoofed user even without a client spoof_user_id") do
        YiffSpace::Auth.enable_spoof_auth!
        assert_not(@controller.logged_in?)

        @controller.spoof_override = { spoof_user_id: "999999" }

        assert(@controller.logged_in?)
        assert_equal("999999", @controller.auth.id)
      end

      test("a controller override still requires the global switch to be on") do
        @controller.spoof_override = { spoof_user_id: "999999" }

        assert_not(@controller.logged_in?)
      end
    end
  end
end
