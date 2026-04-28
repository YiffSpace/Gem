# frozen_string_literal: true

Rails.application.routes.draw do
  mount(YiffSpace::Auth::Engine => "/auth")
  get(:session, to: "application#dump_session")
  root(to: "application#root")
end
