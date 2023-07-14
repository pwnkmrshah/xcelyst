module BxBlockScheduling
  class ScheduleInterviewMailer  < ApplicationMailer
  	before_action :set_inviter_and_invitee

		def schedule_interview_you
			fetch_email(@candidate.email)
		end

		def schedule_interview_admin
			fetch_email()
		end

		def schedule_interview_interview
			fetch_email(@interviewer.email)
		end

		def choose_interview_to_interviewer
			fetch_email(@interviewer.email)
		end

		def choose_interview_to_candidate
			fetch_email(@candidate.email)
		end

		def choose_interview_to_client
			fetch_email(@client.email)
		end

		def meeting_schedule_from_admin_to_client
			fetch_email(@client.email)
		end

		def create_custom_link_mail_to_client
			fetch_email(@client.email)
		end

		def create_custom_link_mail_to_admin
			fetch_email()
		end

		def create_custom_mail_to_candidate
			fetch_email(@candidate.email)
		end

		def request_admin_support
			msg = "Client #{@client.first_name} has request for admin support to pick the interview slot to #{@candidate.first_name}(candidate)."
			mail(to: "info@xcelyst.com", from: 'builder.bx_dev@engineer.ai', subject: 'Request Admin support.', body: "#{msg}")
		end

		def feedback_given_by_interviewer
			fetch_email(@client.email)
		end

		def interviewer_link
			token = BuilderJsonWebToken.encode @interview.id, 'interviewer'
			@link = (ENV["FRONT_END_URL"] ? ENV["FRONT_END_URL"] + "candidate-feedback/" : "https://hiringplatform-74392-react-native.b74392.dev.us-east-1.aws.svc.builder.cafe/candidate-feedback/")+ token
			mail(to: @interviewer.email, subject: "Request for Feedback: #{@candidate.user_full_name}")
		end

		def final_interviewer_link
			token = BuilderJsonWebToken.encode @interview.id, 'interviewer'
			@link = (ENV["FRONT_END_URL"] ? ENV["FRONT_END_URL"] + "candidate-feedback/" : "https://hiringplatform-74392-react-native.b74392.dev.us-east-1.aws.svc.builder.cafe/candidate-feedback/")+ token
			mail(to: @interviewer.email, from: 'builder.bx_dev@engineer.ai', subject: 'Interview completed successfully')
		end

		def set_inviter_and_invitee
			@interview  = @record
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
			fetch_email()
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