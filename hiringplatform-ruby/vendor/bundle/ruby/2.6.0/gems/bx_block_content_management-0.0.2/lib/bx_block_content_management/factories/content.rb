FactoryBot.define do
  factory :content, class: 'BxBlockContentManagement::Content' do
    sub_category
    category
    content_type
    language
    publish_date { DateTime.now}
    status { 'publish' }
    trait :reindex do
      after(:create) do |content, _evaluator|
        content.reindex(refresh: true)
      end
    end
  end
end
