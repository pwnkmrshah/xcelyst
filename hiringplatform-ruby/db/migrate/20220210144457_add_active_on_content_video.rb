class AddActiveOnContentVideo < ActiveRecord::Migration[6.0]
  def change
  	 add_column :content_videos, :active, :boolean, default: false
  end
end
