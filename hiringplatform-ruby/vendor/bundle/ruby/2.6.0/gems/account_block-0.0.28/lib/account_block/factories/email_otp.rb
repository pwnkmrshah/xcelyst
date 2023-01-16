FactoryBot.define do
  factory :email_otp, :class => 'AccountBlock::EmailOtp' do
    email { generate :account_email }
  end
end
