# frozen_string_literal: true

require("active_support/concern")
require("securerandom")

module YiffSpace
  module Auth
    module Helper
      extend(ActiveSupport::Concern)

      module ClassMethods
        def set_client_name(name) # rubocop:disable Naming/AccessorMethodName
          before_action do |controller|
            controller.request.env[CLIENT_NAME_ENV] = name
            if controller.respond_to?(:yiffspace_client_name=)
              controller.yiffspace_client_name = name
            elsif controller.respond_to?(:client_name=)
              controller.client_name = name
            elsif controller.respond_to?(:helpers)
              if controller.helpers.respond_to?(:yiffspace_client_name=)
                controller.helpers.yiffspace_client_name = name
              elsif controller.helpers.respond_to?(:client_name=)
                controller.helpers.client_name = name
              end
            end
          end
        end

        # Disables spoof auth for this controller (or just the actions matched by the given
        # before_action options, e.g. `only:`/`except:`), regardless of the global switch or the
        # client's spoof_user_id. Useful for controllers that must always see the real session
        # (e.g. the auth engine's own login/callback controllers).
        def disable_spoof_auth(**before_action_options)
          before_action(**before_action_options) { |controller| controller.request.env[SPOOF_OVERRIDE_ENV] = false }
        end

        # Overrides the user/permissions/roles spoofed for this controller (or just the actions
        # matched by the given before_action options), independent of the client's configured
        # spoof_user_id/spoof_permissions/spoof_roles. Still requires the global switch
        # (YiffSpace::Auth.enable_spoof_auth!) to be on - this only changes *who* gets spoofed in,
        # not whether spoofing happens at all.
        def override_spoof_auth(spoof_user_id: nil, spoof_permissions: nil, spoof_roles: nil, **before_action_options)
          overrides = { spoof_user_id: spoof_user_id, spoof_permissions: spoof_permissions, spoof_roles: spoof_roles }.compact
          before_action(**before_action_options) { |controller| controller.request.env[SPOOF_OVERRIDE_ENV] = overrides }
        end
      end

      def auth_raw
        read_session_cache(auth_client_config.auth_session_key)
      end

      def auth
        return spoofed_auth if spoofing?
        return AuthInfo::Anonymous.instance if auth_raw.blank?

        AuthInfo.from_session(auth_raw)
      end

      def auth?
        spoofing? || (auth_raw.present? && !auth.anonymous?)
      end

      def auth=(value)
        value = nil if value.is_a?(AuthInfo::Anonymous)
        write_session_cache(auth_client_config.auth_session_key, value&.to_session)
      end

      def reset_auth!
        write_session_cache(auth_client_config.auth_session_key, nil)
      end

      def user_raw
        read_session_cache(auth_client_config.user_session_key)
      end

      def user
        return spoofed_user if spoofing?
        return UserInfo::Anonymous.instance if user_raw.blank?

        UserInfo.from_session(user_raw)
      end

      def user?
        spoofing? || (user_raw.present? && !user.anonymous?)
      end

      def user=(value)
        value = nil if value.is_a?(UserInfo::Anonymous)
        write_session_cache(auth_client_config.user_session_key, value&.to_session)
      end

      def reset_user!
        write_session_cache(auth_client_config.user_session_key, nil)
      end

      def full_reset!
        reset_auth!
        reset_user!
      end

      def require_auth(path)
        redirect_to(path) unless logged_in?
      end

      def logged_in?
        auth? && user?
      end

      def has_permission?(name)
        return false unless logged_in?

        auth.permissions.has?(name)
      end

      # Checks the dirty flag written by the Logto webhook handler. If set, re-fetches
      # the user's current roles and permissions from the Logto Management API and
      # rewrites the session — without waiting for the access token to expire.
      # Call this as a before_action in any controller that needs instant revocation.
      def sync_auth_if_dirty!
        return if spoofing?
        return unless auth?

        flag_key = format(DIRTY_FLAG_KEY, auth.id)
        return unless Rails.cache.exist?(flag_key)

        Rails.cache.delete(flag_key)

        management = auth_client_config.logto_management
        api_user   = management.get_user_by_id(auth.id)

        if api_user.nil? || api_user.data["isSuspended"]
          full_reset!
          return
        end

        roles       = management.get_user_roles(auth.id)
        permissions = roles.flat_map { |role| management.get_role_scopes(role["id"]) }
                           .pluck("name")
                           .uniq

        self.auth = AuthInfo.new(
          id:          auth.id,
          token:       auth.token,
          roles:       roles.pluck("name"),
          permissions: permissions,
          client_id:   auth.client_id,
        )
      end

      def url_helpers
        YiffSpace::Auth::Engine.for(client_name).routes.url_helpers
      end

      # Returns the Auth::Client for the current request. In auth engine controllers this is
      # resolved from the routing default set by Engine.for; in host app controllers it falls
      # back to the default registered client. Override in your controller to choose a specific
      # client when multiple are registered.
      def auth_client_config
        client_name = self.client_name
        client_name.present? ? YiffSpace::Auth[client_name.to_sym] : YiffSpace::Auth.default
      end

      def client_name
        respond_to?(:request, true) && request.env[CLIENT_NAME_ENV]
      end

      def client_name=(value)
        request.env[CLIENT_NAME_ENV] = value.to_sym
      end

      # Per-request override set via the disable_spoof_auth/override_spoof_auth class macros, or
      # by calling this setter directly (e.g. from a custom before_action, for values that can
      # only be computed per-request). `false` disables spoofing; a Hash overrides individual
      # :spoof_user_id/:spoof_permissions/:spoof_roles values; nil (the default) defers entirely
      # to the client's configuration.
      def spoof_override
        respond_to?(:request, true) && request.env[SPOOF_OVERRIDE_ENV]
      end

      def spoof_override=(value)
        request.env[SPOOF_OVERRIDE_ENV] = value
      end

      private

      # True when YiffSpace::Auth.enable_spoof_auth! has been called and a spoof user id resolves
      # (from the client's spoof_user_id or a controller override). Clients without one keep
      # behaving normally even with the global switch on, so spoofing is always opt-in.
      def spoofing?
        YiffSpace::Auth.spoof_auth? && resolved_spoof_user_id.present?
      end

      def resolved_spoof_user_id
        return nil if spoof_override == false

        (spoof_override.is_a?(Hash) && spoof_override[:spoof_user_id]) || auth_client_config.spoof_user_id
      end

      def resolved_spoof_permissions
        (spoof_override.is_a?(Hash) && spoof_override[:spoof_permissions]) || auth_client_config.spoof_permissions
      end

      def resolved_spoof_roles
        (spoof_override.is_a?(Hash) && spoof_override[:spoof_roles]) || auth_client_config.spoof_roles
      end

      # Memoized per-request so repeated calls (controller + views) don't refetch the
      # spoofed user from the Logto Management API on every access.
      def spoofed_user
        @spoofed_user ||= begin
          config    = auth_client_config
          api_user  = config.logto_management.get_or_create_user(resolved_spoof_user_id)
          UserInfo.new(id: api_user.discord_id, user: api_user, discord: api_user.discord.serializable_hash)
        end
      end

      def spoofed_auth
        @spoofed_auth ||= AuthInfo.new(
          id:          spoofed_user.id,
          token:       "spoofed",
          roles:       resolved_spoof_roles,
          permissions: resolved_spoof_permissions,
          client_id:   auth_client_config.client_id,
        )
      end

      def read_session_cache(session_key)
        token = session[session_key]
        return nil if token.blank?

        Rails.cache.read(format(SESSION_CACHE_KEY, token))
      end

      # A fresh token is minted on every write (rather than reusing/refreshing the existing one)
      # so a stale token left over from a previous login can never be replayed to read whatever
      # happens to be written at that cache key next.
      def write_session_cache(session_key, value)
        old_token = session[session_key]
        Rails.cache.delete(format(SESSION_CACHE_KEY, old_token)) if old_token.present?

        if value.nil?
          session.delete(session_key)
          return
        end

        token = SecureRandom.hex(32)
        Rails.cache.write(format(SESSION_CACHE_KEY, token), value, expires_in: SESSION_CACHE_TTL)
        session[session_key] = token
      end

      module Scoped
        extend(ActiveSupport::Concern)
        include(Helper)

        included do
          private(*Helper.instance_methods(false))
          private_class_method(*Helper::ClassMethods.instance_methods(false))
        end

        Helper.instance_methods(false).each do |name|
          define_method("yiffspace_#{name}") { |*args, **kwargs, &block| send(name, *args, **kwargs, &block) }
        end

        module ClassMethods
          include(Helper::ClassMethods)

          Helper::ClassMethods.instance_methods(false).each do |name|
            define_method("yiffspace_#{name}") { |*args, **kwargs, &block| send(name, *args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
