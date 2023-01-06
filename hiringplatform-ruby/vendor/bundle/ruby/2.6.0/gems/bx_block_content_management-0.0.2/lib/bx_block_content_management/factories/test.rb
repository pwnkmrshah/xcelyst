FactoryBot.define do
  factory :test, class: 'BxBlockContentManagement::Test' do
    headline {Faker::Alphanumeric.unique.alphanumeric(7)}
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
