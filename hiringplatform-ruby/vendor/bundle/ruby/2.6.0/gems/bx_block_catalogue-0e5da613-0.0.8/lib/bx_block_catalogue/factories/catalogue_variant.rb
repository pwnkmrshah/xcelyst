FactoryBot.define do
  factory :catalogue_variant, :class => 'BxBlockCatalogue::CatalogueVariant' do
    catalogue { create :catalogue }
    catalogue_variant_color { create :catalogue_variant_color }
    catalogue_variant_size { create :catalogue_variant_size }
    price { 10.5 }
    stock_qty { 3 }
    on_sale { true }
    sale_price { 9 }
    discount_price { 1 }
    length { 3.3 }
    breadth { 2.5 }
    height { 100 }
  end
end
