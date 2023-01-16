BxBlockAppointmentManagement::Engine.routes.draw do
  resources :availabilities, only: [:index, :create] do
    delete :delete_all, on: :collection
  end
end
