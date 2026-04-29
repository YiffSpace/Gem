# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper(YiffSpace::Auth::Helper)

  def root
  end

  def dump
    render(json: {
      params:  params,
      session: session,
    })
  end
end
