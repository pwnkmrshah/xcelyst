module BxBlockDatabase
	class DownloadLimit < ApplicationRecord
		self.table_name = :download_limits

		validates_presence_of :no_of_downloads

	end
end
