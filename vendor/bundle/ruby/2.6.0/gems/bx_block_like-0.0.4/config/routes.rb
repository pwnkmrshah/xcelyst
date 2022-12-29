BxBlockLike::Engine.routes.draw do
  resources :likes, only: [:index, :create, :update, :destroy]
end
