BxBlockFavourites::Engine.routes.draw do
  resources :favourites, only: [:index, :create, :destroy]
end
