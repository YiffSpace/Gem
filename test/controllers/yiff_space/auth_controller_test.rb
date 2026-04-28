# frozen_string_literal: true

require("test_helper")

module YiffSpace
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test("auth engine loads its routes") do
      assert_equal(
        { controller: "yiff_space/auth/root", action: "cb" },
        YiffSpace::Auth::Engine.routes.recognize_path("/cb", method: :get),
      )
      assert_recognizes({ controller: "yiff_space/auth/root", action: "cb" }, "/auth/cb")
    end

    test("auth controller exposes session helper methods through helpers") do
      helper_methods = YiffSpace::Auth::ApplicationController._helpers.instance_methods

      assert_includes(helper_methods, :generate_state!)
      assert_includes(helper_methods, :return_path)
      assert_includes(helper_methods, :return_path=)
      assert_includes(helper_methods, :auth)
      assert_includes(helper_methods, :auth=)
      assert_includes(helper_methods, :auth?)
      assert_includes(helper_methods, :user)
      assert_includes(helper_methods, :user=)
      assert_includes(helper_methods, :user?)
      assert_includes(helper_methods, :require_auth)
      assert_includes(helper_methods, :has_permission?)
    end
  end
end
