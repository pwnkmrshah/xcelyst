FactoryBot.define do
  factory :exam, class: 'BxBlockContentManagement::Exam' do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    to {Date.today}
    from {Date.today + 1.days}
  end
end
