module BxBlockTwilio
  class FavouriteConverstion < ApplicationRecord
    self.table_name = :favourite_converstions
    belongs_to :account, class_name: "AccountBlock::Account"
  end
end
