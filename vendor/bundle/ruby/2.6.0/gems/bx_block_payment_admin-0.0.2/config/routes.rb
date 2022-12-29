BxBlockPaymentAdmin::Engine.routes.draw do
  resources :payment_admin, :only => [:index, :show]
end
