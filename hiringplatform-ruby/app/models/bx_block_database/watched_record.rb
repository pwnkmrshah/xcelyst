module BxBlockDatabase
  class WatchedRecord < ApplicationRecord
    self.table_name = :watched_records

    belongs_to :temporary_user_database, class_name: "BxBlockDatabase::TemporaryUserDatabase", dependent: :destroy

    validates :ip_address, presence: true
    
  end
end
