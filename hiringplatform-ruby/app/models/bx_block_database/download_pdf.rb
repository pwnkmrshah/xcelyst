module BxBlockDatabase
  class DownloadPdf < ApplicationRecord
    self.table_name = :download_pdfs

    belongs_to :temporary_user_database, class_name: 'BxBlockDatabase::TemporaryUserDatabase'

    validates_presence_of :ip_address, :download_on

  end
end
