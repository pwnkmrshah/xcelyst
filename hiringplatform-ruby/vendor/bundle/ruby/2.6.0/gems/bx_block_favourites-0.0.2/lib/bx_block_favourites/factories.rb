FactoryBot.define do
  factory :favourite, :class => "BxBlockFavourites::Favourite" do
    association :favouriteable, factory: :account
  end
end

