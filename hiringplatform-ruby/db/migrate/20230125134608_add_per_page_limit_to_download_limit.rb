class AddPerPageLimitToDownloadLimit < ActiveRecord::Migration[6.0]
  def change
    add_column :download_limits, :per_page_limit, :integer
  end
end
