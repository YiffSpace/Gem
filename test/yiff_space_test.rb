# frozen_string_literal: true

require("test_helper")

class YiffSpaceTest < ActiveSupport::TestCase
  test("it has a version number") do
    assert(YiffSpace::VERSION)
  end

  test("autoloads nested constants through zeitwerk") do
    assert(YiffSpace::Auth::Engine < Rails::Engine)
    assert_equal(YiffSpace::Utils::OpenHash, YiffSpace::Utils::OpenHash)
    assert_includes(YiffSpace::Extensions::Hash::ToOpenHash.instance_methods, :to_open_hash)
    assert_equal(YiffSpace::Images::Avatar::Discord, YiffSpace::Images::Avatar.find_type(:discord))
  end
end
