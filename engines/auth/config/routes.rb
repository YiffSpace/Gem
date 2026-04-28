# frozen_string_literal: true

YiffSpace::Auth::Engine.routes.draw do
  get(:cb, controller: :root)
  get(:logout, controller: :root)
  get(:permissions, controller: :root)
  root(action: :show, controller: :root, as: :auth)
end
