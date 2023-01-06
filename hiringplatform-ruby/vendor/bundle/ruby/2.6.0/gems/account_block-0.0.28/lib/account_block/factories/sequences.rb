FactoryBot.define do
  sequence(:account_email) { |n| "email-#{n}@acme.com" }
  sequence(:phone_number) { |n| "+1 310 854 #{n.to_s.rjust(4, '0')}" }
end
