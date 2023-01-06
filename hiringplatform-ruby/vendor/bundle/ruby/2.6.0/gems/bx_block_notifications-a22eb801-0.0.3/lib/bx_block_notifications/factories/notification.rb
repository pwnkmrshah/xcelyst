FactoryBot.define do
  factory :notification, :class => 'BxBlockNotifications::Notification' do
    headings { "test" }
    created_by {1}
    contents {"test"}
    app_url {"url_test"}
    is_read {false}
    read_at { "20/02/2020" }
    account
  end
end
