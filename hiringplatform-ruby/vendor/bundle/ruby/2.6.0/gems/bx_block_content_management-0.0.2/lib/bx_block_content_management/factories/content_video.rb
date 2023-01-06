FactoryBot.define do
  factory :content_video, class: 'BxBlockContentManagement::ContentVideo' do
    separate_section { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
  end
end
