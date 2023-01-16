BxBlockRequestManagement::Engine.routes.draw do
  resources :requests, only: [:index, :create, :update, :show]
end
