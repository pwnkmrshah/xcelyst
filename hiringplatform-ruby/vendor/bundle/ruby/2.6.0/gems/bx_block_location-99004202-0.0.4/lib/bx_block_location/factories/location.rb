FactoryBot.define do
  factory :location, :class => 'BxBlockLocation::Location' do
    latitude { 22.9734229 }
    longitude { 78.6568942 }
    van { create :van }
  end
end
