FactoryBot.define do
  factory :account, :class => 'AccountBlock::Account' do
    password { 'password' }

    factory :email_account, :class => 'AccountBlock::EmailAccount' do
      email { generate :account_email }
    end

    factory :sms_account, :class => 'AccountBlock::SmsAccount' do
      full_phone_number { generate :phone_number }
    end
  end
end
