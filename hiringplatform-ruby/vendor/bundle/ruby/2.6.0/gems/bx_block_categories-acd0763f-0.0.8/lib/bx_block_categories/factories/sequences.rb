FactoryBot.define do
  sequence(:category_name) { |n| "category_#{n}" }
  sequence(:sub_category_name) { |n| "sub_category_#{n}" }
end
