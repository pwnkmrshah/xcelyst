BxBlockCustomAds::Engine.routes.draw do
  resources :advertisements, only: %i(create show index)
end
