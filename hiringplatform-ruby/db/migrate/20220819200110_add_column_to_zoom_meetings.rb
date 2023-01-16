class AddColumnToZoomMeetings < ActiveRecord::Migration[6.0]
  def change
    add_column :zoom_meetings, :provider, :string
    remove_column :zoom_meetings, :zoom_id
    add_column :zoom_meetings, :zoom_id, :bigint
  end
end
