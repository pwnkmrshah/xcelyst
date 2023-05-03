require 'sidekiq/web'
require 'sidekiq/cron/web'
require "action_cable/engine"

Rails.application.routes.draw do

  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :user_admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  require 'sidekiq/cron/web'
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => '/cable'

  root to: "admin/dashboard#index"
  namespace :account_block do
    resource :accounts do
      put :verify_otp
      put :resend_otp
      put :update_account
      post '/photo_update', to: 'accounts#photo_update'
      get '/remove_photo', to: 'accounts#remove_photo'
      get '/reset_password/:id', to: 'accounts#reset_password', as: 'change_password'
    end
    get '/accounts_setpassword', to: 'accounts#set_password'
    post '/account/update', to: 'accounts#update'
  end

  namespace :bx_block_upload_media do 
    put 'get_presigned_url', to: 'upload_media#get_presigned_url' 
  end

  namespace :bx_block_login do
    resource :logins, only: :create 
    post '/client_login', to: 'logins#client_login'
  end

  namespace :bx_block_sovren do
    # resources :soverens, only: :create
    put 'remove_resume', to: 'soverens#remove_resume'
    put 'update_resume', to: 'soverens#update_resume'
    post 'create_jd', to: 'soverens#job_description'
    put 'update_jd/:jd_id', to: 'soverens#update_job_description'

    post 'bulk_resume', to: 'bulk_uploads#resume'
    post 'sample_parser', to: 'bulk_uploads#sample_resume_parser'
  end

  namespace :bx_block_shortlisting do
    resources :shortlisting_candidates, only: :create
    post 'get_jd', to: 'shortlisting_candidates#get_jd'
    post 'get_roles', to: 'shortlisting_candidates#get_roles'
    post 'bulk_send_messages', to: 'shortlisting_candidates#bulk_send_messages'
    post 'bulk_send_messages_to_account', to: 'shortlisting_candidates#bulk_send_messages_to_account'
    post 'shortlist_creation', to: 'shortlisting_candidates#shortlist_creation'
    get 'get_shortlisted', to: 'shortlisting_candidates#get_shortlisted'
    post 'get_candidate', to: 'shortlisting_candidates#get_candidate'
    post 'attach_temp_resume_file', to: "shortlisting_candidates#attach_temp_resume_file"
    post 'create_parsed_json_file', to: "shortlisting_candidates#create_parsed_json_file"
  end

  namespace :bx_block_test_dome do
    resources :test_domes
    post '/auth_token_generation', to: 'test_domes#auth_token_generation'
    delete '/delete_all', to: 'test_domes#delete_all'
  end

  namespace :bx_block_forgot_password do
    resource :passwords, only: :create
    post '/request_otp', to: 'passwords#request_otp'
    post '/request_otp_client', to: 'passwords#request_otp_client'
  end
  
  namespace :bx_block_requestdemo do
    resource :request_demos, only: :create
  end

  namespace :bx_block_contact_us do
    # post 'contacts', to: 'contacts#create'
    resource :contacts, only: :create
  end
  

  namespace :bx_block_aboutpage do 
    get '/aboutpage', to: 'about_page#show'
    post '/page_preview', to: 'about_page#page_preview'
  end
  
  namespace :bx_block_profile do
    resource :profile, only: :create
    post '/appied_job_list', to: 'profiles#appied_job_list'
    post '/profile_show', to: 'profiles#show'
    post '/recommended_roles', to: 'profiles#recommended_roles'
    post '/past_appied_job_list', to: 'profiles#past_appied_job_list'
    get '/filters', to: 'profiles#filters'
  end

  namespace :bx_block_roles_permissions do 
    resource :roles
    resource :applied_jobs do 
      put '/proceed', to: 'applied_jobs#proceed'
      post '/applied_user_search', to: 'applied_jobs#applied_user_search'
    end
    post '/get_roles', to: 'roles#get_roles'
    post '/create_job_description', to: 'roles#create_job_description'
    post '/apply_candidate_list', to: 'roles#apply_candidate_list'
    post '/search_role', to: 'roles#search_role'
    post '/search_candiate', to: 'roles#search_candiate'
    post '/candidate_accessment_list', to: 'roles#candidate_accessment_list'
    post '/candidate_accessment', to: 'roles#candidate_accessment'
    get '/search_candidate_accessment', to: 'roles#search_candidate_accessment'
    post '/close_role', to: 'roles#close_role'
  end

  namespace :bx_block_content_management do
    resource :content_types
    get '/get_data', to: 'content_types#get_data'
    get '/get_content', to: 'content_types#get_content'
    get '/get_banner', to: 'content_types#get_banner'
    get '/get_social_media_link', to: 'content_types#get_social_media_link'
  end


  namespace :bx_block_job_description do
    post '/show', to: 'job_description#show'
    post '/get_preferred_data', to: 'job_description#get_preferred_data'
  end

  namespace :bx_block_business_function do 
    resource :business_domains
  end

  namespace :bx_block_suggestion do
    get '/job_suggestions', to: 'job_suggestions#show'
  end

  namespace :bx_block_feedback do
    resources :feedback_parameter_lists
    resources :interview_feedbacks, only: :create
     get 'interview_feedbacks/:applied_job_id', to: 'interview_feedbacks#show'
  end

  namespace :bx_block_dev do
    post '/create_account', to: 'devloper#create_account'
  end

  get 'bx_block_scheduling/profile/:user_id', to: 'bx_block_scheduling/candidate_profile#profile'

  namespace :bx_block_scheduling do 
    resources :schedule_interviews, only: [:create, :show, :update]
    get '/interviewers', to: 'schedule_interviews#interviewers'
    get '/feedbacks_drop', to: 'schedule_interviews#feedbacks_drop'
    get '/interviewer_feedback_link/:id', to: "schedule_interviews#interviewer_feedback_link", as: "interviewer_feedback_link"
    get '/get_interview_for_interviewer', to: 'schedule_interviews#get_interview_for_interviewer', as: "get_interview_for_interviewer"
    put '/interviewer_feedback', to: 'schedule_interviews#interviewer_feedback'
  end
   
  namespace :bx_block_save_job do
    resource :save_jobs, only: :create
    post '/show', to: 'save_jobs#show'
  end

  namespace :bx_block_information do 
    resources :term_conditions, only: :index
    resources :privacy_policies, only: :index
  end

  namespace :bx_block_twilio do 
    resources :chat_conversations
    post '/create_conversations', to: "chat_conversations#create_conversations"
    post '/user_detail', to: 'chat_conversations#user_detail'
    delete '/delete_conversation', to: 'chat_conversations#delete_conversation'
    post '/custom_message', to: 'chat_conversations#custom_message'
    resource :favourite_converstion
  end

  namespace :bx_block_database do 
    resources :temporary_user_databases, only: [:index, :create]
    resources :watched_records, only: :create
    get "suggectiones", to: "temporary_user_databases#suggectiones"
    get "create_index", to: "temporary_user_databases#create_index"
    get 'download_pdf/:id', to: 'temporary_user_databases#download_pdf'
  end

  namespace :bx_block_job do 
    resources :job_database, only: [:index, :create]
    get "suggestions", to: "job_database#suggestions"
  end

  namespace :bx_block_cfzoomintegration3 do
    resources :zoom_meetings, only: [:show]
    post 'interview', to: 'zoom_meetings#get_schedule_interview'
  end

  namespace :bx_block_notifications do
    resource :notifications
  end

  namespace :bx_block_admin do 
    # resource :admin_users, only: [:create]
    resources :admin_client_dashboard, only: :index
    resources :admin_login, only: :create
    put 'otp_verify', to: 'admin_login#otp_verify'
    put 'refresh_token', to: 'admin_login#refresh_token'
    post 'logout', to: 'admin_login#logout'
    get 'resend_otp', to: 'admin_login#resend_otp'

    get 'client/search', to: 'admin_client_dashboard#client_search'
    get "/fetch_whatsapp_chats", to: "admin_users#fetch_whatsapp_chats"
    get "/fetch_whatsapp_messges", to: "admin_users#fetch_whatsapp_messges"
    post "/send_messages", to: "admin_users#send_messages"
  end

  get '/webhook/whatsapp', to: "webhook#whatsapp"
  post '/webhook/whatsapp', to: "webhook#receive_request"

  put "user_resume_json_upload", to: "task#user_resume_file_upload"
  put "temp_account_json_upload", to: "task#temp_account_file_upload"

end