FactoryBot.define do
  factory :company_page, class: 'BxBlockJoblisting::CompanyPage' do
    company_name{"cptest#{rand(1_00-9_99)}"}
    website{"www.abc.com"}
    company_tagline{"WE PRODUCE DEVELOPERS"}
    country{"India"}
    address{"Indore"}
    postal_code{"452011"}
    company_description{"This is a platform to search jobs"}
  end
end
