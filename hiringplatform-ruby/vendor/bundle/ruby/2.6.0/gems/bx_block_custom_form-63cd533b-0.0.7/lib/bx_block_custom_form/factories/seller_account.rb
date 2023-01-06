FactoryBot.define do
  factory :seller_account, :class => 'BxBlockCustomForm::SellerAccount' do
    firm_name { 'Seller firm' }
    full_phone_number { '+380620600161632' }
    location { 'Seller location' }
    country_code { 'USA' }
    phone_number { '0620600161632' }
    account { create :email_account }
  end
end
