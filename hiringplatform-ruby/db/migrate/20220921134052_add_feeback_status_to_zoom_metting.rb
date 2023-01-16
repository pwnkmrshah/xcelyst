class AddFeebackStatusToZoomMetting < ActiveRecord::Migration[6.0]
  def change
    add_column :zoom_meetings, :feedback_nofi_status, :integer
  end
end