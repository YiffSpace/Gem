# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper(YiffSpace::Auth::SessionHelper)

  def root
  end

  def dump_session
    render(json: session)
  end
end
