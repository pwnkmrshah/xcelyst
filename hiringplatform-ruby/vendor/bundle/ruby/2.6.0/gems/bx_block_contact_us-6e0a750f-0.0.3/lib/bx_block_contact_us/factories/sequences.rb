FactoryBot.define do
  sequence(:contact_name) { |n| "contact_#{n}" }
  sequence(:contact_email) { |n| "emai#{n}@mail.com" }
end
