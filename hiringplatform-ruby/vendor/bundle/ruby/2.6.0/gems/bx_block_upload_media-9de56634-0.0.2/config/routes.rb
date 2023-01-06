BxBlockUploadMedia::Engine.routes.draw do
  resources :upload_media, only: %i(create index) do
    collection do
      patch :bulk_upload
      post :upload_banner
      get :fetch_advertise_banner
    end
  end
end
