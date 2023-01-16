FactoryBot.define do
  factory :epub, class: 'BxBlockContentManagement::Epub' do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
