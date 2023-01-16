FactoryBot.define do
  factory :content_text, class: 'BxBlockContentManagement::ContentText' do
    content { Faker::Alphanumeric.unique.alphanumeric(7) }
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    hyperlink { Faker::Alphanumeric.unique.alphanumeric(20) }
    affiliation { Faker::Alphanumeric.unique.alphanumeric(7) }
  end
end
