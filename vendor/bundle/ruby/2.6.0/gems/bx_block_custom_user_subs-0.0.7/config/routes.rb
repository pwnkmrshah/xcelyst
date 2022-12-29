BxBlockCustomUserSubs::Engine.routes.draw do
  resources :subscriptions, only: %i(index)
  resources :user_subscriptions, only: %i(index show create)
end
