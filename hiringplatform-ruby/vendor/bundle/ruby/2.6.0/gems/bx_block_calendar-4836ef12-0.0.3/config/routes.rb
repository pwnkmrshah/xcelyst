BxBlockCalendar::Engine.routes.draw do
  resources :availabilities, only: [:create] do
    collection  do
      post :update_availability_time
      #get :get_booked_time_slots
    end
  end
  resources :booked_slots, only: :index
end
