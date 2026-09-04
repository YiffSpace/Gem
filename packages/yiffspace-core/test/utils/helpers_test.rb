# frozen_string_literal: true

require("test_helper")

class HelpersTest < ActiveSupport::TestCase
  test("forwards keyword arguments to the underlying helper as keywords") do
    assert_equal("Hello, Fenrir!", YiffSpace::Utils::Helpers.greeting("Fenrir"))
    assert_equal("HELLO, FENRIR!", YiffSpace::Utils::Helpers.greeting("Fenrir", loud: true))
  end

  test("still forwards positional arguments alongside keywords") do
    assert_equal("HELLO, FENRIR?", YiffSpace::Utils::Helpers.greeting("Fenrir", "?", loud: true))
  end

  test("makes route helpers callable from inside a helper method") do
    assert_equal("Home: /?loud=true", YiffSpace::Utils::Helpers.root_link)
  end

  test("also exposes route helpers directly through the proxy") do
    assert_equal("/?tags=male", YiffSpace::Utils::Helpers.root_path(tags: "male"))
  end
end
