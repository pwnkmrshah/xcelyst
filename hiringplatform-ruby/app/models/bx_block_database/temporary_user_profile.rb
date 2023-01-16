module BxBlockDatabase
  class TemporaryUserProfile < ApplicationRecord
    self.table_name = :temporary_user_profiles

    belongs_to :temporary_user_database, class_name: "BxBlockDatabase::TemporaryUserDatabase"
  end
end
