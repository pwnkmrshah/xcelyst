FactoryBot.define do
  factory :catalogue_variant_size, :class =>
      'BxBlockCatalogue::CatalogueVariantSize' do
    name { generate :catalogue_variant_size_name }
  end
end
