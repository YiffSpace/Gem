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

      def method_missing(name, *, &)
        target.send(name, *, &)
      end

      def respond_to_missing?(...)
        target.respond_to?(...)
      end

      private

      # Lazily resolved so application is not referenced at load time.
      def target
        Rails.application.routes.url_helpers
      end
    end
  end
end
