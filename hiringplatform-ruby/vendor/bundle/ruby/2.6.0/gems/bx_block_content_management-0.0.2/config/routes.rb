BxBlockContentManagement::Engine.routes.draw do
  resources :contents, only: %i[show index] do
    collection do
      get :get_content_detail
      post :reindex_contents
      get :run_seeds
      post :contents
    end
  end
  resources :authors, only: %i[show index]
  resources :follows, only: %i[create destroy index]
  resources :bookmarks, only: %i[create destroy index]
  resources :content_types, only: %i[index]
  resources :tags, only: %i[index]
  resources :exams, only: %i[show index]
end
