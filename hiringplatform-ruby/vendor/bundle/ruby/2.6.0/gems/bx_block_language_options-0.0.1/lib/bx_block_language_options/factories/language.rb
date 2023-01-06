FactoryBot.define do
  factory :language, class: 'BxBlockLanguageOptions::Language' do
    name { Faker::Name.unique.name }
    language_code {Faker::Name.unique.name}
  end
end
