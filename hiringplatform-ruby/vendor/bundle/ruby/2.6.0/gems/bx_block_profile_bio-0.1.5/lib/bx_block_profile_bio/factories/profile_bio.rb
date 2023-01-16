# frozen_string_literal: true

FactoryBot.define do
  factory :profile_bio, class: 'BxBlockProfileBio::ProfileBio' do
    height { '5.5' }
    weight { '50' }
    height_type { 'foot' }
    weight_type { 'kg' }
    body_type { 'Athletic' }
    mother_tougue { 'Hindi' }
    religion { 'Jain' }
    zodiac { 'Taurus' }
    marital_status { 'Married' }
    smoking { 'No' }
    drinking { 'No' }
    # looking_for {"Marriage"}
    about_me { 'test' }
    about_business { 'test' }
    personality { ['test 01', 'test 02', 'test 03'] }
    interests { ['test 01', 'test 02', 'test 03'] }
    languages { %w[test01 test02 test03] }
    account
  end
end
