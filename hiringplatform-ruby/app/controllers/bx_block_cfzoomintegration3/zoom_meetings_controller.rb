module BxBlockCfzoomintegration3
	class ZoomMeetingsController < ApplicationController
  		skip_before_action :validate_json_web_token, only: [:get_schedule_interview, :index]
  		before_action :schedule_interview, only: :show

  		# created by akash deep
  		# to get the scedule interview details.
		def get_schedule_interview
			interviews = BxBlockScheduling::ScheduleInterview.where(account_id: params[:candidate_id], client_id: params[:client_id], require_admin_support: true)
			if interviews.present?
				records = get_role_name interviews
				render json: { data: records }, status: 200
			else
				render json: { message: "No Interview Scheduled." }, status: 404
			end
		end

		# created by akash deep
		# to show zoom meeting details for the schedule interview.
		def show
			zoom_meeting = @interview.zoom_meeting
			if zoom_meeting.present?
				ending_at = Time.parse(params[:ending_at]).seconds_since_midnight.to_s
				zoom_meeting.update(schedule_date: params[:schedule_date], ending_at: ending_at)
				render json: { data: zoom_meeting }, status: 200
			else
				render json: { message: "No zoom meeting present." }, status: 422
			end
		end

		private

		def get_role_name interviews
			interview_records = []
			interviews.each do |interview|
				rec = {
					id: interview.id,
					name: interview.role.name,
					preferred_slot: interview.preferred_slot.present? ? interview.send("#{interview.preferred_slot}_slot") : nil
				}
				interview_records << rec
			end
			interview_records
		end

		def schedule_interview
			@interview = BxBlockScheduling::ScheduleInterview.find_by(id: params[:id])
			unless @interview.present?
				return render json: { message: "Interview record not present." }, status: 200
			end
		end

	end
end