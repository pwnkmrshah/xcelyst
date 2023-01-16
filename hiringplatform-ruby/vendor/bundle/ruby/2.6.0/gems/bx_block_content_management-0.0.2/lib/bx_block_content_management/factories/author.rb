FactoryBot.define do
  factory :author, class: 'BxBlockContentManagement::Author' do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    bio { Faker::Alphanumeric.unique.alphanumeric(7) }
    # publishing_date_and_time {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)}
  end
end
