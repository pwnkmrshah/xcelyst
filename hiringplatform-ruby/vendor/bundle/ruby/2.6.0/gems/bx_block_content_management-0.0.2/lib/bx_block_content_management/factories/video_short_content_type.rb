FactoryBot.define do
  factory :video_short_content_type, class: 'BxBlockContentManagement::ContentType' do
    name { "Videos (short)" }
    type { "Videos" }
    identifier { "video_short" }
  end
end
