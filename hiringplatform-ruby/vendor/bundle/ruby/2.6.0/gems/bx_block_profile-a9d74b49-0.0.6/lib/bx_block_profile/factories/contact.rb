FactoryBot.define do
  factory :contact, class: 'BxBlockContactsintegration::Contact' do
    first_name{"abc#{rand(1_00-9_99)}"}
    last_name{ "xyz #{rand(1_00-9_99)}" }
    full_phone_number{ "91#{rand(9_000000000..9_999999999)}" }
    email{"te#{rand(1_00000..9_99999)}@mailinator.com"}
    # profile_id { 10 }
  end
end
