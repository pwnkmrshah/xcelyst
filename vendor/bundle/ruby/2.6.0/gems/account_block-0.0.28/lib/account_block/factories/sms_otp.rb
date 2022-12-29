FactoryBot.define do
  factory :sms_otp, :class => 'AccountBlock::SmsOtp' do
    # Do not send SMS for objects created using the factory
    before(:create) do |user|
      user.define_singleton_method(:send_pin_via_sms) {}
    end

    full_phone_number { generate :phone_number }
  end
end

