# frozen_string_literal: true

module YiffSpace
  module Utils
    module Helpers
      module_function

      def method_missing(name, *, &)
        helpers = ApplicationController.helpers
        return helpers.public_send(name, *, &) if helpers.respond_to?(name)

        super
      end

      def respond_to_missing?(name, include_private = false)
        ApplicationController.helpers.respond_to?(name, include_private) || super
      end
    end
  end
end
