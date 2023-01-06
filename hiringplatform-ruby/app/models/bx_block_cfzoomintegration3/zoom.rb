module BxBlockCfzoomintegration3
	class Zoom < ApplicationRecord
		self.table_name = :zooms

		has_many :zoom_meetings, class_name: "BxBlockCfzoomintegration3::ZoomMeeting", dependent: :destroy

		validates_presence_of :zoom_user_id, :email, :first_name, :last_name
		validates_presence_of :status, inclusion: { in: %w(active inactive) }
		validates_uniqueness_of :zoom_user_id, scope: :email

	end
end

