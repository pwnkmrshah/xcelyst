BxBlockLocation::Engine.routes.draw do
  resources :vans, only: %i(show update) do
    collection do
      get :near_vans
      get :estimated_arrival_time
    end
  end
end
