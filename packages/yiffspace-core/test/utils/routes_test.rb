# frozen_string_literal: true

require("test_helper")

class RoutesTest < ActiveSupport::TestCase
  test("forwards keyword arguments to the underlying route helper") do
    assert_equal("/?loud=true", YiffSpace::Utils::Routes.root_path(loud: true))
  end
end
