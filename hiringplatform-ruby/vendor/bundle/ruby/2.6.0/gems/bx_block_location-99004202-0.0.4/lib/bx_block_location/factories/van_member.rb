FactoryBot.define do
  factory :van_member, :class => 'BxBlockLocation::VanMember' do
    account { create :email_account }
    van { create :van }
  end
end
