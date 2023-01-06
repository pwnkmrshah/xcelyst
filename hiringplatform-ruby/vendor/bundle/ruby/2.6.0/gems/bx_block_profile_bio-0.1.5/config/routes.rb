# frozen_string_literal: true

BxBlockProfileBio::Engine.routes.draw do
  resources :profile_bios, only: %i[create update show]
  resources :preferences, only: %i[create index]
  get 'preferences/reset_preference', to: 'preferences#reset_preference'
  resources :view_profiles, only: %i[create index]
  put 'preferences/update', to: 'preferences#update'
  get 'fetch_personalities', to: 'profile_bios#fetch_personalities'
  get 'fetch_interests', to: 'profile_bios#fetch_interests'
end
