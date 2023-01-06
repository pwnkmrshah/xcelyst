BxBlockPosts::Engine.routes.draw do
  resources :posts, only: [:create, :show, :index, :update, :destroy] do
    collection do
      get :search
    end
  end
end
