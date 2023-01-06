BxBlockScheduling::Engine.routes.draw do
  resources :service_provider_schedulings, only: [] do
    collection do
      get :get_sp_details
    end
  end
end
