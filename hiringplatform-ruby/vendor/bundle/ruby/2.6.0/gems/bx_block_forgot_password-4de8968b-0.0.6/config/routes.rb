BxBlockForgotPassword::Engine.routes.draw do
  resource :otp, :only => [:create]
  resource :otp_confirmation, :only => [:create]
  resource :password, :only => [:create]
end
