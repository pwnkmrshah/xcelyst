module BxBlockSchedule
	class InterviewerFeedbackNotiWorker
		include Sidekiq::Worker

		# Create by Punit
		# Send the Email Notification to Interviwer for Feedback.
		def perform(*args)
			zoom_meetings = BxBlockCfzoomintegration3::ZoomMeeting.where(feedback_nofi_status: [0,1,2,3])
			zoom_meetings.present? && zoom_meetings.each do |zoom_meeting|
				interview = zoom_meeting.interview
				unless interview.feedback.present?
					value = BxBlockCfzoomintegration3::ZoomMeeting.feedback_nofi_statuses[zoom_meeting.feedback_nofi_status] + 1
					# If Email Notification send alread send 3 time so will send last email to Interviewer
					if zoom_meeting.feedback_nofi_status  == "forth_nofi"
						zoom_meeting.update(feedback_nofi_status: value)
						BxBlockScheduling::ScheduleInterviewMailer.with(interview: interview).final_interviewer_link.deliver_now
					else
						zoom_meeting.update(feedback_nofi_status: value)
						BxBlockScheduling::ScheduleInterviewMailer.with(interview: interview).interviewer_link.deliver_now
					end
				end
			end
		end

	end
end