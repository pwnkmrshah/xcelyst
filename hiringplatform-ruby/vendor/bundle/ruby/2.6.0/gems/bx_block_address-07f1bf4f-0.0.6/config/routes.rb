BxBlockAddress::Engine.routes.draw do
  resources :addresses, :only => [:create, :index, :update]
end
