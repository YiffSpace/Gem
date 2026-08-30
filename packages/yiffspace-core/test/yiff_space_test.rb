# frozen_string_literal: true

require("test_helper")

class YiffSpaceTest < ActiveSupport::TestCase
  test("it has a version number") do
    assert(YiffSpace::Core::VERSION)
  end

  test("autoloads nested constants through zeitwerk") do
    assert(YiffSpace::Engine < Rails::Engine)
    assert_equal(YiffSpace::Utils::OpenHash, YiffSpace::Utils::OpenHash)
  end
end
