FactoryBot.define do
  factory :project, class: 'BxBlockProfile::Project' do
    project_name{"test_project"}
    start_date{Time.at(rand(51.years))}
    end_date{Time.at(rand(50.years))}
    add_members{"2"}
    url{"https://abc/pqr"}
    description{"description"}
    make_projects_public{true}
  end
end


