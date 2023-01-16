FactoryBot.define do
    factory :payment_admin, :class => 'BxBlockPaymentAdmin::PaymentAdmin' do
      transaction_id {"test"}
      current_user_id {nil}
      account
      third_party_amount {10.2}
      admin_amount {10}
      user_amount{100}
      payment_method { "paypal" }
      payment_status { "completed" }
    end
end
