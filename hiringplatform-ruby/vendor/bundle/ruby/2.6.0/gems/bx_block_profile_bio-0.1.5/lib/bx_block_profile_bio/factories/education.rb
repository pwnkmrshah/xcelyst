# frozen_string_literal: true

FactoryBot.define do
  factory :education, class: 'BxBlockProfileBio::Education' do
    qualification { 'BCA' }
    description { 'Testing' }
    year_from { '2010' }
    year_to { '2013' }
  end
end
