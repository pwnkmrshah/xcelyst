FactoryBot.define do
  factory :like, class: 'BxBlockLike::Like' do
    like_by_id { account.id }
    likeable_id { post.id }
    likeable_type { 'BxBlockPost::Post' }
  end
end
