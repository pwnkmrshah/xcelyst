FactoryBot.define do
  factory :privacy_policy, :class => 'BxBlockPrivacySettings::PrivacyPolicy' do
    description { "Private policy default description" }
  end
end
