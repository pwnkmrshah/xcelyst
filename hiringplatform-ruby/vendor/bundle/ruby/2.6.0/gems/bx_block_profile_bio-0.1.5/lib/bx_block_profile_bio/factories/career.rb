# frozen_string_literal: true

FactoryBot.define do
  factory :career, class: 'BxBlockProfileBio::Career' do
    profession { 'Software developer' }
    is_current { false }
    experience_from { '2018' }
    experience_to { '2020' }
    payscale { '8-9 lakh' }
    company_name { Faker::Company.name }
    sector { 'Private' }
    accomplishment { %w[demo01 demo02 demo03] }
  end
end
