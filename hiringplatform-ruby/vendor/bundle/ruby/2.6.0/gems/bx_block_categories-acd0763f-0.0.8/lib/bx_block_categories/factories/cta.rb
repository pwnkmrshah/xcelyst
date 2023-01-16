FactoryBot.define do
  factory :cta, class: 'BxBlockCategories::Cta' do
    headline { Faker::Alphanumeric.unique.alphanumeric(7) }
    description { Faker::Alphanumeric.unique.alphanumeric(15) }
    category
    is_square_cta { true }
    is_long_rectangle_cta { true }
    is_text_cta { true }
    is_image_cta { true }
    has_button { true }
    visible_on_details_page { true }
    visible_on_home_page { true }
    text_alignment {"left"}
    button_alignment {"left"}
    button_text {"ok"}
    redirect_url { 'localhost:300/bx_category'}
  end
end
