# frozen_string_literal: true

FactoryBot.define do
  factory :request, class: 'BxBlockRequestManagement::Request' do
    account_id { create(:profile_bio).account_id }
    sender_id { create(:profile_bio).account_id }
    status { nil }
  end
end
