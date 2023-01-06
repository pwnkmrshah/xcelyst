BxBlockEmailNotifications::Engine.routes.draw do
  resources :email_notifications, only: [:create, :show]
end
