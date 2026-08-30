# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Images
    class AvatarTest < ActiveSupport::TestCase
      test("find_type resolves a registered avatar type") do
        assert_equal(Avatar::Discord, Avatar.find_type(:discord))
        assert_equal(Avatar::Gravatar, Avatar.find_type(:gravatar))
      end

      test("find_type returns nil for an unregistered type") do
        assert_nil(Avatar.find_type(:nonexistent))
      end

      test("find_type! raises for an unregistered type") do
        assert_raises(StandardError) { Avatar.find_type!(:nonexistent) }
      end
    end
  end
end
