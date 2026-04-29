# frozen_string_literal: true

Rails.application.routes.draw do
  mount(YiffSpace::Auth::Engine.for(:default) => "/auth")
  get(:dump, controller: "application")
  root(to: "application#root")
end
