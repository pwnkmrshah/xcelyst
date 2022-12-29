# frozen_string_literal: true

BxBlockPlan::Engine.routes.draw do
  resources :plans, only: [:index]
end
