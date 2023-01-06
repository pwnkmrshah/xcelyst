module BxBlockSchedule
	class ScheduleInterviewFeedbackWorker
		include Sidekiq::Worker

		def perform(*args)
			# cur_time = Time.parse(Time.zone.now.to_datetime.to_s(:time)).seconds_since_midnight.to_s
			# plus_5_min_time = Time.parse((Time.zone.now+4.minutes).to_datetime.to_s(:time)).seconds_since_midnight.to_s
			# zoom_meetings = zoom_meetings.where('ending_at BETWEEN ? AND ?', cur_time, plus_5_min_time)
			# if zoom_meetings.present?
			# 	zoom_meetings.each do |meet|
			# 		delivered_in = (meet.ending_at.to_f - cur_time.to_f)
			# 		@interview = meet.interview
			# 		BxBlockScheduling::ScheduleInterviewMailer.with(interview: @interview).interviewer_link.deliver_later(wait: delivered_in.seconds)
			# 	end
			# end

			zoom_meetings = BxBlockCfzoomintegration3::ZoomMeeting.where(schedule_date: Time.zone.now.to_date)
			zoom_meetings.each do |zoom_meeting|
				interview = zoom_meeting.interview
				if interview.time_zone.present?
					cur_time = Time.parse(Time.now.in_time_zone(interview.time_zone).to_datetime.to_s(:time)).seconds_since_midnight.to_s
					plus_5_min_time = Time.parse((Time.now+4.minutes).in_time_zone(interview.time_zone).to_datetime.to_s(:time)).seconds_since_midnight.to_s

					if zoom_meeting.ending_at.between?(cur_time, plus_5_min_time)
						delivered_in = (zoom_meeting.ending_at.to_f - cur_time.to_f)
						zoom_meeting.update(feedback_nofi_status: 0)
						BxBlockScheduling::ScheduleInterviewMailer.with(interview: interview).interviewer_link.deliver_later(wait: delivered_in.seconds)
					end
				end
			end
		end

	end
end