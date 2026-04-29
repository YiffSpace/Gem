# frozen_string_literal: true

module YiffSpace
  module Auth
    class RootController < ApplicationController
      include(Helper)

      def show
        state            = generate_state!
        self.return_path = params[:path]
        redirect_to(auth_client_config.url(state: state), allow_other_host: true)
      end

      def cb
        return render("yiff_space/error", locals: { message: "missing code in request" }, status: :bad_request) if params[:code].blank?
        return render("yiff_space/error", locals: { message: "missing state in request" }, status: :bad_request) if params[:state].blank?
        return render("yiff_space/error", locals: { message: "invalid state in request" }, status: :bad_request) if params[:state] != state

        reset_state!
        exchange  = auth_client_config.exchange(params[:code])
        self.auth = exchange.auth
        self.user = exchange.user
        path      = return_path
        action    = auth_client_config.after_auth_action
        reset_return_path!
        if action.is_a?(Proc)
          instance_exec(*(action.arity == 0 ? [] : [path]), &action)
          return if performed?
        elsif action.is_a?(String)
          return redirect_to(action)
        end

        redirect_to(path || "/")
      end

      def permissions
      end

      def logout
        return redirect_back_or_to("/") if auth.blank? && user.blank?
        self.return_path = params[:path] # sanitization
        path             = return_path
        action           = auth_client_config.after_logout_action
        full_reset!
        if action.is_a?(Proc)
          action.call(*[self, path].slice(0, action.arity))
          return if performed?
        elsif action.is_a?(String)
          return redirect_to(action)
        end

        redirect_to(path || "/")
      end

      def debug
        return render("yiff_space/error", locals: { message: "Access Denied" }, status: :forbidden) unless YiffSpace::Auth.enable_debug_action?

        render(json: {
          env:     request.env.select { |env| env.start_with?("yiffspace.") },
          params:  params,
          session: session,
          client:  auth_client_config.as_json.merge(client_secret: "[REDACTED]"),
        })
      end
    end
  end
end
