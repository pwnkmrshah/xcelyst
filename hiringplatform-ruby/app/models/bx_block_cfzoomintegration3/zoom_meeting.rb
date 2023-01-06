module BxBlockCfzoomintegration3
  class ZoomMeeting < ApplicationRecord
    self.table_name = :zoom_meetings

    belongs_to :zoom, class_name: 'BxBlockCfzoomintegration3::Zoom', optional: true
    belongs_to :interview, class_name: 'BxBlockScheduling::ScheduleInterview', foreign_key: 'schedule_interview_id'
    belongs_to :candidate, class_name: 'AccountBlock::Account', foreign_key: 'candidate_id'
    belongs_to :client, class_name: 'AccountBlock::Account', foreign_key: 'client_id'

    validates_presence_of :schedule_date, :starting_at, :meeting_urls
    validates_presence_of :provider, inclusion: { in: %w(zoom google_meet teams) }
    enum feedback_nofi_status: { first_nofi: 0, second_nofi: 1, third_nofi: 2, forth_nofi: 3, block_nofi: 4 }
  end
end