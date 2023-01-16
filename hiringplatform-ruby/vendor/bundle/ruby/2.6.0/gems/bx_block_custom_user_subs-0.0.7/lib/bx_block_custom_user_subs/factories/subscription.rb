FactoryBot.define do
  factory :subscription, :class => 'BxBlockCustomUserSubs::Subscription' do
    name { 'Subscription name' }
    description { 'Description' }
    price { 10 }
    valid_up_to { Date.today + 1.year }
  end
end
