# frozen_string_literal: true

FactoryBot.define do
  factory :view_profile, class: 'BxBlockProfileBio::ViewProfile' do
    profile_bio_id { 1 }
    view_by_id { 1 }
  end
end
