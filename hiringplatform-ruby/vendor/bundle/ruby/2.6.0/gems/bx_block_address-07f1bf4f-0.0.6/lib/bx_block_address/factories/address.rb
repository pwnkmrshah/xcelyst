FactoryBot.define do
  factory :address, :class => 'BxBlockAddress::Address' do
    addressble_id { (create :email_account).id }
    latitude { 22.9734229 }
    longitude { 78.6568942 }
    address { 'Random location for the test' }
    address_type { 'Home' }
  end
end
