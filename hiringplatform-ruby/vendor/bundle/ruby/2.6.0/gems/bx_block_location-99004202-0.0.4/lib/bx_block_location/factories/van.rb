FactoryBot.define do
  factory :van, :class => 'BxBlockLocation::Van' do
    transient do
      service_provider { create :email_account }
    end

    name { "#{service_provider.first_name}_#{service_provider.id}_vans" }
    bio { 'Test van s bio' }
    is_offline { false }
  end
end
