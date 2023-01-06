FactoryBot.define do
  factory :reference , class: 'BxBlockAddreferences::Reference' do
    name {"abc#{rand(1_00-9_99)}"}
    company_name { "xyz #{rand(1_00-9_99)}" }
    phone_no { "91#{rand(9_000000000..9_999999999)}" }
    email {"te#{rand(1_00000..9_99999)}@mailinator.com"}
    how_do_you_know_them {"abc#{rand(1_00-9_99)}"}
  end
end
