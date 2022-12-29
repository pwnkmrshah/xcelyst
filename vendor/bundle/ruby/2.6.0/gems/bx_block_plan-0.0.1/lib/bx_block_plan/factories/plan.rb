# frozen_string_literal: true

FactoryBot.define do
  factory :plan, class: 'BxBlockPlan::Plan' do
    name { 'BCA' }
    duration { '6 Months' }
    price { 350_000 }
    details { 'Bachelor degree' }
  end
end
