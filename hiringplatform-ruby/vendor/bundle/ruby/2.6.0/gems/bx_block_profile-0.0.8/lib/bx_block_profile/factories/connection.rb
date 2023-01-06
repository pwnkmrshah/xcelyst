FactoryBot.define do
  factory :connection, class: 'BxBlockAddfriends::Connection' do
    account_id { rand(1_00-9_99) }
    receipient_id { rand(1_00-9_99) }
  end
end
