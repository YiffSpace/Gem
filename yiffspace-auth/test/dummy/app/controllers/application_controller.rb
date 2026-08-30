# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include(YiffSpace::Auth::Helper)

  helper(YiffSpace::Auth::Helper)
  set_client_name(:test)

  def root; end

  def dump
    render(json: {
      env_client_name: request.env[YiffSpace::Auth::CLIENT_NAME_ENV],
      client_name:     helpers.client_name,
      params:          params,
      session:         session,
    })
  end
end
