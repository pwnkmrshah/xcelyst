FactoryBot.define do
  factory :review, :class => 'BxBlockCatalogue::Review' do
    catalogue { create :catalogue }
    rating { 10 }
    comment { 'A comment' }
  end
end
