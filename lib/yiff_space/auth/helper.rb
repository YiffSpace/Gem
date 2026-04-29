# frozen_string_literal: true

require("active_support/concern")

module YiffSpace
  module Auth
    module Helper
      extend(ActiveSupport::Concern)

      module ClassMethods
        def set_client_name(name)
          before_action do |request|
            if request.respond_to?(:yiffspace_client_name=)
              request.yiffspace_client_name = name
            elsif request.respond_to?(:client_name=)
              request.client_name = name
            elsif request.respond_to?(:helpers)
              if request.helpers.respond_to?(:yiffspace_client_name=)
                request.helpers.yiffspace_client_name = name
              elsif request.helpers.respond_to?(:client_name=)
                request.helpers.client_name = name
              end
            end
          end
        end
      end

      def auth_raw
        session[auth_client_config.auth_session_key]
      end

      def auth
        return AuthInfo::Anonymous.instance if auth_raw.blank?
        AuthInfo.from_session(auth_raw)
      end

      def auth?
        auth_raw.present? && !auth.anonymous?
      end

      def auth=(value)
        value                                        = nil if value.is_a?(AuthInfo::Anonymous)
        session[auth_client_config.auth_session_key] = value&.to_session
      end

      def reset_auth!
        session.delete(auth_client_config.auth_session_key)
      end

      def user_raw
        session[auth_client_config.user_session_key]
      end

      def user
        return UserInfo::Anonymous.instance if user_raw.blank?
        UserInfo.from_session(user_raw)
      end

      def user?
        user_raw.present? && !user.anonymous?
      end

      def user=(value)
        value                                        = nil if value.is_a?(UserInfo::Anonymous)
        session[auth_client_config.user_session_key] = value&.to_session
      end

      def reset_user!
        session.delete(auth_client_config.user_session_key)
      end

      def state
        session[auth_client_config.state_session_key]
      end

      def state=(value)
        session[auth_client_config.state_session_key] = value
      end

      def reset_state!
        session.delete(auth_client_config.state_session_key)
      end

      def generate_state!
        generator  = auth_client_config.state_generator
        self.state = generator.call(*(generator.arity == 0 ? [] : [self]))
      end

      def return_path
        session[auth_client_config.return_path_session_key]
      end

      def return_path=(value)
        return if value && (!value.start_with?("/") || value.start_with?("//"))
        session[auth_client_config.return_path_session_key] = value
      end

      def reset_return_path!
        session.delete(auth_client_config.return_path_session_key)
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
        respond_to?(:params, true) && params[:yiffspace_auth_client_name]
      end

      def client_name=(value)
        params[:yiffspace_auth_client_name] = value.to_sym
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
