FactoryBot.define do
  factory :user_subscription,
          :class => 'BxBlockCustomUserSubs::UserSubscription' do
    subscription { create :subscription }
    account { create :email_account }
  end
end
