FactoryBot.define do
  factory :category, :class => 'BxBlockCategories::Category' do
    name { generate :category_name }
  end
end
