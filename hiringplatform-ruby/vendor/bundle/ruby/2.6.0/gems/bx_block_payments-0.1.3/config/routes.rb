BxBlockPayments::Engine.routes.draw do
  resources :razorpays, only: [:show, :create, :update]
end
