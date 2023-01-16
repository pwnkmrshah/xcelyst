FactoryBot.define do
  factory :advertisement, :class => 'BxBlockCustomAds::Advertisement' do
    name { generate :category_name }
    description { 'Advertisement description' }
    plan_id { 1 }
    duration { '1 day' }
    advertisement_for { 1 }
    status { 1 }
    seller_account { create :seller_account }
    start_at { DateTime.now }
    expire_at { DateTime.now + 1.day }
  end
end
