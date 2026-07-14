# frozen_string_literal: true

module YiffSpace
  module Utils
    module Helpers
      module_function

      # Uses send/respond_to?(name, true) (not public_send/respond_to?(name)) because host apps
      # commonly call helpers through this proxy with an explicit receiver (e.g. a decorator's
      # `h.some_helper`), including ones marked private in their helper module - private only
      # restricts calling with an explicit receiver, and normal view rendering (which invokes
      # helpers without one) isn't affected either way.
      def method_missing(name, *, &)
        helpers = YiffSpace.config.application_controller_class.helpers
        return helpers.send(name, *, &) if helpers.respond_to?(name, true)

        super
      end

      def respond_to_missing?(name, include_private = false)
        YiffSpace.config.application_controller_class.helpers.respond_to?(name, true) || super
      end
    end
  end
end
