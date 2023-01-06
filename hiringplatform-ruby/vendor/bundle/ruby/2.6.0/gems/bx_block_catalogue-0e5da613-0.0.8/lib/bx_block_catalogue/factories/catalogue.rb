FactoryBot.define do
  factory :catalogue, :class => 'BxBlockCatalogue::Catalogue' do
    category { create :category }
    sub_category { create :sub_category }
    brand { create :brand }
    name { generate :catalogue_name }
    sku { 'sku-1' }
    description { 'Catalogue description' }
    manufacture_date { DateTime.now }
    length { 10.5 }
    breadth { 1.5 }
    height { 2 }
    stock_qty { 10 }
    availability { 'in_stock' }
    weight {2.2 }
    price { 0.1 }
    recommended { true }
    on_sale { false }
    sale_price { 0.05 }
    discount { 0.2 }
  end
end
