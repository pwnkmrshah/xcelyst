class AddScheduleInterviewToZoomMeetings < ActiveRecord::Migration[6.0]
  def change
    BxBlockCfzoomintegration3::ZoomMeeting.destroy_all if BxBlockCfzoomintegration3::ZoomMeeting.count > 0
    add_reference :zoom_meetings, :schedule_interview, null: false, foreign_key: true
  end
end
