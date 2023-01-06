FactoryBot.define do
  factory :audio_podcast, class: 'BxBlockContentManagement::AudioPodcast' do
    heading { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(20) }
  end
end
