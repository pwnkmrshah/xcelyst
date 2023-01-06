FactoryBot.define do
  factory :bookmark, class: 'BxBlockContentManagement::Bookmark' do
    content
    account
  end
end
