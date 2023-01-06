FactoryBot.define do
  factory :test_score, class: 'BxBlockProfile::TestScoreAndCourse' do
    title{"test_score"}
    associated_with{"company#{rand(1_00000..9_99999)} test"}
    score{"60/100"}
    test_date{Time.at(rand(51.years))}
    description{"test description"}
    make_public{true}
    profile_id{nil}
  end
end


