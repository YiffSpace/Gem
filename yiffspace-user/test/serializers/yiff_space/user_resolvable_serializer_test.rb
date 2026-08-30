# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Serializers
    class UserResolvableSerializerTest < ActiveSupport::TestCase
      setup do
        @user_class = Class.new do
          attr_reader(:id)

          def initialize(id) = @id = id
          def self.find(id) = new(id)
        end
        @saved_user_class = YiffSpace.config.instance_variable_get(:@user_class)
        YiffSpace.config.user_class = @user_class
      end

      teardown do
        YiffSpace.config.user_class = @saved_user_class
      end

      test("serializes user id and ip_addr") do
        user       = @user_class.new(42)
        resolvable = User::Resolvable.new(user, "1.2.3.4")
        serializer = UserResolvableSerializer.instance

        result = serializer.serialize(resolvable)

        assert_equal(42, result["user"])
        assert_equal("1.2.3.4", result["ip_addr"])
      end

      test("deserializes hash back to UserResolvable") do
        serializer = UserResolvableSerializer.instance

        result = serializer.deserialize({ "user" => 42, "ip_addr" => "1.2.3.4" })

        assert_instance_of(User::Resolvable, result)
        assert_equal(42, result.user.id)
        assert_equal("1.2.3.4", result.ip_addr)
      end

      test("round-trips through serialize and deserialize") do
        user       = @user_class.new(99)
        resolvable = User::Resolvable.new(user, "10.0.0.1")
        serializer = UserResolvableSerializer.instance

        restored = serializer.deserialize(serializer.serialize(resolvable))

        assert_instance_of(User::Resolvable, restored)
        assert_equal(99, restored.user.id)
        assert_equal("10.0.0.1", restored.ip_addr)
      end

      test("serialize? returns true for UserResolvable") do
        user       = @user_class.new(1)
        resolvable = User::Resolvable.new(user, "127.0.0.1")
        serializer = UserResolvableSerializer.instance

        assert(serializer.serialize?(resolvable))
      end

      test("serialize? returns false for non-UserResolvable") do
        serializer = UserResolvableSerializer.instance

        assert_not(serializer.serialize?(@user_class.new(1)))
        assert_not(serializer.serialize?("string"))
        assert_not(serializer.serialize?(nil))
      end
    end
  end
end
