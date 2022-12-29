BxBlockCategories::Engine.routes.draw do
  resources :categories do
    collection do
      put 'update_user_categories'
    end
  end
  resources :sub_categories do
    collection do
      put 'update_user_sub_categories'
    end
  end
  resources :cta, only: %i[index]
end
