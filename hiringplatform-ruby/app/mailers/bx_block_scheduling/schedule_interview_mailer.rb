module BxBlockScheduling
  class ScheduleInterviewMailer  < ApplicationMailer
		before_action :set_inviter_and_invitee
    before_action :set_values
		
		def schedule_interview_you
			fetch_email('schedule_interview_you')
		end

		def schedule_interview_admin
			fetch_email('schedule_interview_admin')
		end

		def schedule_interview_interview
			fetch_email('schedule_interview_interview')
		end

		def choose_interview_to_interviewer
			fetch_email('choose_interview_to_interviewer')
		end

		def choose_interview_to_candidate
			fetch_email('choose_interview_to_candidate')
		end

		def choose_interview_to_client
			fetch_email('choose_interview_to_client')
		end

		def meeting_schedule_from_admin_to_client
			fetch_email('meeting_schedule_from_admin_to_client')
		end

		def create_custom_link_mail_to_client
			fetch_email('create_custom_link_mail_to_client')
		end

		def create_custom_link_mail_to_admin
			fetch_email('create_custom_link_mail_to_admin')
		end

		def create_custom_mail_to_candidate
			mail(to: @candidate.email, from: 'builder.bx_dev@engineer.ai', subject: 'Time Slot Choosed Successfully.')
		end

		def request_admin_support
			msg = "Client #{@client.first_name} has request for admin support to pick the interview slot to #{@candidate.first_name}(candidate)."
			mail(to: "info@xcelyst.com", from: 'builder.bx_dev@engineer.ai', subject: 'Request Admin support.', body: "#{msg}")
		end

		def feedback_given_by_interviewer
			msg = "Feedback has been submitted by #{@interviewer.name}."
			mail(to: @client.email, from: 'builder.bx_dev@engineer.ai', subject: 'Feedback has been submitted.', body: "#{msg}")
		end

		def set_inviter_and_invitee
			@interview  = params[:interview]
			@candidate = @interview.candidate
			@job_title = @interview&.job_description.job_title
			@candidate_name = @candidate.user_full_name
			@client = @interview.client
			@interviewer = @interview.interviewer
			@zoom_meeting = @interview&.zoom_meeting
			@starting_at = @zoom_meeting&.starting_at 
			@schedule_date = @zoom_meeting&.schedule_date 
		end


		def interviewer_link
			fetch_email('interviewer_link')
		end

		def final_interviewer_link
			token = BuilderJsonWebToken.encode @interview.id, 'interviewer'
			@link = (ENV["FRONT_END_URL"] ? ENV["FRONT_END_URL"] + "candidate-feedback/" : "https://hiringplatform-74392-react-native.b74392.dev.us-east-1.aws.svc.builder.cafe/candidate-feedback/")+ token
			mail(to: @interviewer.email, from: 'builder.bx_dev@engineer.ai', subject: 'Interview completed successfully')
		end

		private

		def get_solt(interview)
			  query = interview.preferred_slot + "_slot"
			  slot = interview[query]
		end
	end
end