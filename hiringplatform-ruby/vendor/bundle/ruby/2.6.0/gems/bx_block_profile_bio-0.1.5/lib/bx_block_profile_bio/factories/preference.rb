# frozen_string_literal: true

FactoryBot.define do
  factory :preference, class: 'BxBlockProfileBio::Preference' do
    seeking { 'Female' }
    discover_people { 'random' }
    location { 'test' }
    distance { '50' }
    height_type { 'foot' }
    body_type { 'Athletic' }
    religion { 'Hindu' }
    smoking { 'No' }
    drinking { 'No' }
    friend { true }
    business { true }
    match_making { true }
    travel_partner { true }
    cross_path { true }
    age_range_start { 27 }
    age_range_end { 32 }
    height_range_start { 5 }
    height_range_end { 6 }
  end
end
