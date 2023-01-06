FactoryBot.define do
  factory :profile, class: 'BxBlockProfile::Profile' do
    country{"india"}
    address{ "street #{rand(1_00-9_99)} mp" }
    postal_code{"452001"}
    profile_role{"jobseeker"}
  end
end
