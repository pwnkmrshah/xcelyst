BxBlockProfile::Engine.routes.draw do
  resource :profile, :only => [:show, :update]
  resource :password, :only => [:update]
  resource :change_phone_validation, :only => [:create]
  resources :validations, :only => [:index]

  get 'user_profiles', to: 'profiles#user_profiles'
  resources :employment_types, only: [:create,:index,:show]
  resources :career_experiences, only: [:index, :create, :show, :update, :destroy]
  resources :profiles, only: [:create,:show,:destroy] do
    put :update_profile, on: :member
  end
  resources :current_status, only: [:create]
  resources :publication_patents, only: [:create,:show,:destroy, :index]
  resources :awards, only: [:create,:show,:destroy, :index]
  resources :test_score_and_courses, only: [:create,:show,:destroy, :index]
  resources :hobbies, only: [:create,:show,:destroy, :index]
  resources :courses, only: [:create, :show, :destroy, :index]
  resources :educational_qualifications, only: [:index, :create, :show, :update, :destroy]
  resources :projects, only: [:index, :create, :show, :update, :destroy]
  resources :languages, only: [:index, :create, :show, :update, :destroy] do
    get :proficiency, on: :collection
  end
end
