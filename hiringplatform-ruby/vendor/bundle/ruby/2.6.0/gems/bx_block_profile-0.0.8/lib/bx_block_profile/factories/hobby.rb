FactoryBot.define do
  factory :hobby, class: 'BxBlockProfile::Hobby' do
    title{"hobby"}
    category{"entertainment"}
    description{"test description"}
    make_public{true}
    profile_id{nil}
  end
end
