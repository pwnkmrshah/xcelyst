# frozen_string_literal: true

FactoryBot.define do
  factory :achievement, class: 'BxBlockProfileBio::Achievement' do
    title { Faker::Team.name }
    achievement_date { Faker::Date.forward(days: 23) }
    detail { 'Testing' }
    url { 'http://localhost.in' }
  end
end
