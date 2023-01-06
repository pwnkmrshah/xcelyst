# frozen_string_literal: true

FactoryBot.define do
  factory :profile_bio_category, class: 'BxBlockProfileBiosCategories::ProfileBioCategory' do
    profile_bio
    category
  end
end
