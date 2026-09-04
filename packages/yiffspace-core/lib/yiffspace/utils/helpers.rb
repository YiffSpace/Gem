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
      def method_missing(name, ...)
        helpers = target
        return helpers.send(name, ...) if helpers.respond_to?(name, true)

        super
      end

      def respond_to_missing?(name, include_private = false)
        target.respond_to?(name, true) || super
      end

      # ApplicationController.helpers behaves like a view for registered helper modules, but
      # (unlike an actual view) doesn't include the app's route url_helpers - so a helper method
      # invoked through this proxy couldn't call `some_path`/`some_url` itself. Extend the shared
      # proxy once so route helpers are available from inside helper methods too, not just to
      # callers going through this module directly.
      #
      # `extend`ing the generated url_helpers module only grants the path/url helper methods
      # themselves - they're written to call `url_options`/`_routes`/`optimize_routes_generation?`
      # on whatever they're called on, and the module only defines those three on its own
      # singleton class (so it works standalone), not as instance methods `extend` would carry
      # over. Delegate them by hand so the extended methods have what they need to run.
      def target
        helpers = YiffSpace.config.application_controller_class.helpers
        url_helpers = Rails.application.routes.url_helpers
        unless helpers.is_a?(url_helpers)
          helpers.define_singleton_method(:url_options) { url_helpers.url_options }
          helpers.define_singleton_method(:_routes) { url_helpers._routes }
          helpers.define_singleton_method(:optimize_routes_generation?) { url_helpers.optimize_routes_generation? }
          helpers.extend(url_helpers)
        end
        helpers
      end
      private_class_method(:target)
    end
  end
end
