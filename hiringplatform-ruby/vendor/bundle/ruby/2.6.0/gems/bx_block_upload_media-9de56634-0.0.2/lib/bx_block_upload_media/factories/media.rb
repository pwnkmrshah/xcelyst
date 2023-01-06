FactoryBot.define do
  factory :media, :class => 'BxBlockUploadMedia::Media' do
    imageable_type { 'BxBlockCustomForm::SellerAccount' }
    imageable_id { (create :seller_account).id }
    file_name { 'testing.jpeg' }
    file_size { '1111' }
    category { 'visiting_card' }
    status { 'approved' }
    presigned_url { 'test.com' }
  end
end
