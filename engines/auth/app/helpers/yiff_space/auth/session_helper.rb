# frozen_string_literal: true

module YiffSpace
  module Auth
    module SessionHelper
      def auth_raw
        session[YiffSpace.config.auth.auth_session_key]
      end

      def auth
        return AuthInfo::Anonymous.instance if auth_raw.blank?
        AuthInfo.from_session(auth_raw)
      end

      def auth?
        auth_raw.present? && !auth.anonymous?
      end

      def auth=(value)
        value                                           = nil if value.is_a?(AuthInfo::Anonymous)
        session[YiffSpace.config.auth.auth_session_key] = value&.to_session
      end

      def reset_auth!
        session.delete(YiffSpace.config.auth.auth_session_key)
      end

      def user_raw
        session[YiffSpace.config.auth.user_session_key]
      end

      def user
        return UserInfo::Anonymous.instance if user_raw.blank?
        UserInfo.from_session(user_raw)
      end

      def user?
        user_raw.present? && !user.anonymous?
      end

      def user=(value)
        value                                           = nil if value.is_a?(UserInfo::Anonymous)
        session[YiffSpace.config.auth.user_session_key] = value&.to_session
      end

      def reset_user!
        session.delete(YiffSpace.config.auth.user_session_key)
      end

      def state
        session[YiffSpace.config.auth.state_session_key]
      end

      def state=(value)
        session[YiffSpace.config.auth.state_session_key] = value
      end

      def reset_state!
        session.delete(YiffSpace.config.auth.state_session_key)
      end

      def generate_state!
        generator  = YiffSpace.config.auth.state_generator
        self.state = generator.call(*(generator.arity == 0 ? [] : [self]))
      end

      def return_path
        session[YiffSpace.config.auth.return_path_session_key]
      end

      def return_path=(value)
        return if value && (!value.start_with?("/") || value.start_with?("//"))
        session[YiffSpace.config.auth.return_path_session_key] = value
      end

      def reset_return_path!
        session.delete(YiffSpace.config.auth.return_path_session_key)
      end

      def full_reset!
        reset_state!
        reset_auth!
        reset_user!
        reset_return_path!
      end

      def require_auth(path)
        redirect_to(path) unless auth?
      end

      def has_permission?(name)
        return false unless auth?
        auth.permissions.has?(name)
      end

      module Scoped
        include(SessionHelper)

        SessionHelper.instance_methods(false).each do |name|
          define_method("yiffspace_#{name}") { |*args, **kwargs, &block| send(name, *args, **kwargs, &block) }
          private(name) # rubocop:disable Style/AccessModifierDeclarations
        end
      end
    end
  end
end
