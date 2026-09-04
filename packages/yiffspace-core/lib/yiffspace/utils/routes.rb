# frozen_string_literal: true

module YiffSpace
  module Utils
    # Allow Rails URL helpers to be used outside of views.
    #
    # @example
    #   Routes.posts_path(tags: "male")
    #   => "/posts?tags=male"
    #
    # @see config/routes.rb
    # @see https://guides.rubyonrails.org/routing.html
    module Routes
      module_function

      def method_missing(name, ...)
        url_helpers = Rails.application.routes.url_helpers
        return url_helpers.public_send(name, ...) if url_helpers.respond_to?(name)

        super
      end

      def respond_to_missing?(name, include_private = false)
        Rails.application.routes.url_helpers.respond_to?(name, include_private) || super
      end
    end
  end
end
