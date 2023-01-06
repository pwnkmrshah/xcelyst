AccountBlock::Engine.routes.draw do
  resources :accounts, only: [:create] do
    collection do
      get :search
    end
  end

  namespace :accounts do
    resource :country_code_and_flag, :only => [:show]
    resource :email_confirmation, :only => [:show]
    resource :sms_confirmation, :only => [:create]
    resource :send_otp, :only => [:create]
  end
end
