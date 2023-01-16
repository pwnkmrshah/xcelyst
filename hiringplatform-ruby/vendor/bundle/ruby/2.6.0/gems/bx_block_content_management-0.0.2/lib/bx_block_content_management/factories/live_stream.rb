FactoryBot.define do
  factory :live_stream, class: 'BxBlockContentManagement::LiveStream' do
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(7) }
    comment_section { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
