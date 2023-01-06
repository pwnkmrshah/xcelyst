FactoryBot.define do
  factory :catalogue_variant_color, :class =>
      'BxBlockCatalogue::CatalogueVariantColor' do
    name { generate :catalogue_variant_color_name }
  end
end
