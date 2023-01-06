FactoryBot.define do
  factory :video_long_content_type, class: 'BxBlockContentManagement::ContentType' do
    name { "Videos (full length)" }
    type { "Videos" }
    identifier { "video_full" }
  end
end
