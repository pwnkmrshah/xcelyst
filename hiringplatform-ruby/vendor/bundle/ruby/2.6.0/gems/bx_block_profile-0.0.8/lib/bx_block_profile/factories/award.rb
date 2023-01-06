FactoryBot.define do
  factory :award, class: 'BxBlockProfile::Award' do
    title{"award"}
    associated_with{"company#{rand(1_00000..9_99999)} test"}
    issuer{"issuer#{rand(1_00000..9_99999)} test"}
    issue_date{Time.at(rand(51.years))}
    description{"test description"}
    make_public{true}
    profile_id{nil}
  end
end


