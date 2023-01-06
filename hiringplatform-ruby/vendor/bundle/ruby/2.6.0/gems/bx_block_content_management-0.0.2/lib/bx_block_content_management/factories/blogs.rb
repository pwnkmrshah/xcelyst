FactoryBot.define do
  factory :blogs, class: 'BxBlockContentManagement::ContentText' do
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    content { Faker::Alphanumeric.unique.alphanumeric(20) }
    hyperlink { Faker::Alphanumeric.unique.alphanumeric(20) }
    affiliation { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
