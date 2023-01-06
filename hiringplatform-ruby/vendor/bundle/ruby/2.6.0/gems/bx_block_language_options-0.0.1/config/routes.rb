BxBlockLanguageOptions::Engine.routes.draw do
  resources :languages, only: %i[index update] do
    collection do
      post 'set_app_language'
      get 'get_all_translations'
      get 'last_translation_time'
    end
  end
end
