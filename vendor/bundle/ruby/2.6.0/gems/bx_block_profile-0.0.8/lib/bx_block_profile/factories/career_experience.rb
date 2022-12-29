FactoryBot.define do
  factory :career_experience, class: 'BxBlockProfile::CareerExperience' do
    job_title{"abc"}
    start_date{Time.at(rand(51.years))}
    end_date{Time.at(rand(50.years))}
    company_name{"xyz company"}
    description{"description"}
    add_key_achievements{"achievements"}
    make_key_achievements_public{true}
  end
end




