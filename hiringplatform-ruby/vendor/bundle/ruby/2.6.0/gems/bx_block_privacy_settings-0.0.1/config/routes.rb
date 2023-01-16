# frozen_string_literal: true

BxBlockPrivacySettings::Engine.routes.draw do
  get '/settings/show', to: 'privacy_settings#show_setting'
  get  '/privacy_policies', to: 'privacy_policies#show'
  get  '/settings/activities', to: 'privacy_settings#activities'
  get  '/settings/push_notifications', to: 'privacy_settings#push_notifications'
  put  '/settings/update_activity', to: 'privacy_settings#update_activity'
  put  '/settings/update_push_notification', to: 'privacy_settings#update_push_notification'
  get  '/terms_and_conditions', to: 'terms_and_conditions#show'
end
