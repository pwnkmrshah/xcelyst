FactoryBot.define do
  factory :request, :class => 'BxBlockRequestManagement::Request' do
    account_id { create(:account).id }
    sender_id { create(:account).id }
    status { nil }
  end
end
