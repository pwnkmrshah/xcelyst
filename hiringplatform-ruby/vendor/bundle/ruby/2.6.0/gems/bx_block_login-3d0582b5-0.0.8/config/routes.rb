BxBlockLogin::Engine.routes.draw do
  resource :login, :only => [:create]
end
