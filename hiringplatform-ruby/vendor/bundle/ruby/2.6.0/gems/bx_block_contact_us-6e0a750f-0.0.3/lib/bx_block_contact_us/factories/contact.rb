FactoryBot.define do
  factory :contact, :class => 'BxBlockContactUs::Contact' do
    account_id { (create :account).id }
    name { generate :contact_name }
    email { generate :contact_email }
    description { 'Contact description' }
    phone_number { '+380465547173' }
  end
end
