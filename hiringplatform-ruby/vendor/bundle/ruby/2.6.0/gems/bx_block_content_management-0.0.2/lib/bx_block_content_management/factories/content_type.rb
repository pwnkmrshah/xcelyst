FactoryBot.define do
  factory :content_type, class: 'BxBlockContentManagement::ContentType' do
    name { Faker::Alphanumeric.unique.alphanumeric(7) }
    type { "AudioPodcast" }
  end
end
