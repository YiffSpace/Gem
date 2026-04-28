# frozen_string_literal: true

module YiffSpace
  module Auth
    class RootController < ApplicationController
      def show
        state               = helpers.generate_state!
        helpers.return_path = params[:path]
        redirect_to(YiffSpace::Auth.url(state: state), allow_other_host: true)
      end

      def cb
        return render("error", locals: { message: "missing code in request" }, status: :bad_request) if params[:code].blank?
        return render("error", locals: { message: "missing state in request" }, status: :bad_request) if params[:state].blank?
        return render("error", locals: { message: "invalid state in request" }, status: :bad_request) if params[:state] != session[YiffSpace.config.auth.state_session_key]

        helpers.reset_state!
        exchange     = Auth.exchange(params[:code])
        helpers.auth = exchange.auth
        helpers.user = exchange.user
        path         = helpers.return_path
        action       = YiffSpace.config.auth.after_auth_action
        helpers.reset_return_path!
        if action.is_a?(Proc)
          instance_exec(*(action.arity == 0 ? [] : [path]), &action)
          return if performed?
        elsif action.is_a?(String)
          return redirect_to(action)
        end

        redirect_to(path || "/")
      end

      def logout
        return redirect_back_or_to("/") if helpers.auth.blank? && helpers.user.blank?
        helpers.return_path = params[:path] # sanitization
        path                = helpers.return_path
        action              = YiffSpace.config.auth.after_logout_action
        helpers.full_reset!
        if action.is_a?(Proc)
          action.call(*[self, path].slice(0, action.arity))
          return if performed?
        elsif action.is_a?(String)
          return redirect_to(action)
        end

        redirect_to(path || "/")
      end
    end
  end
end
