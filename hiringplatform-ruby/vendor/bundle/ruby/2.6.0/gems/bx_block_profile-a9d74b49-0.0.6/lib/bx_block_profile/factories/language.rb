FactoryBot.define do
  factory :language, class: 'BxBlockProfile::Language' do
    proficiency{"advance"}
    language{"english"}
    profile_id{nil}
  end
end
