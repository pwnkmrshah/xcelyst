module BxBlockScheduling
  class ScheduleInterviewsController < ApplicationController
    before_action :current_user, only: [:create, :show, :update, :interviewers]
    before_action :check_user_role, only: :create
    before_action :find_interview_record, only: [:show, :update, :interviewer_feedback_link]
    before_action :find_interview_to_token, only: [:get_interview_for_interviewer, :interviewer_feedback]
    before_action :is_feedback_given?, only: :interviewer_feedback

    # Create by Punit 
    # Create Interview for Candidate by Clinet
    def create
      interview = ScheduleInterview.new(interviews_params)
      interview.client_id = @current_user.id
      if interview.save
        mailer = BxBlockScheduling::ScheduleInterviewMailer.with(interview: interview)
        if interview.require_admin_support
          mailer.request_admin_support.deliver_now
          mailer.schedule_interview_interview.deliver_now
          mailer.schedule_interview_you.deliver_now
        else
          mailer.schedule_interview_you.deliver_now
          mailer.schedule_interview_admin.deliver_now
          mailer.schedule_interview_interview.deliver_now
        end
        render json: ScheduleInterviewSerializer.new(interview).serializable_hash, status: :created
      else
        render json: { errors: interview.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Create by Punit
    # Show the inteviewe Details 
    def show
      if @current_user.user_role == "client"
        if @interview.client_id == @current_user.id
          render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
        else
          render json: { errors: "Not belongs to your job description." }
        end
      elsif @current_user.user_role == "candidate"
        if @interview.account_id == @current_user.id
          render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
        else
          render json: { errors: "Not belongs to your applied jobs." }
        end
      end
    end

    # Create by Punit
    # Update the Schedule Interview Client or Candidates both 
    def update
      if @current_user.user_role == "client"
        if @interview.client_id == @current_user.id
          @interview.update client_params
          render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
        else
          render json: { errors: "Not belongs to your job description." }
        end
      elsif @current_user.user_role == "candidate"

        if @interview.account_id == @current_user.id
          begin
            ActiveRecord::Base.transaction(isolation: :serializable) do
              x = BxBlockCfzoomintegration3::ZoomOperations.new.create_meeting_urls(params[:zoom], @interview) # call the create_meeting_urls here 
              if x.success?
                @interview.update! candidate_params
                mailer = ScheduleInterviewMailer.with(interview: @interview)
                mailer.choose_interview_to_interviewer.deliver_now
                mailer.choose_interview_to_candidate.deliver_now
                mailer.choose_interview_to_client.deliver_now 
                return render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
              else
                @interview.update!(candidate_params.merge(require_admin_support: true))  # update candidate params here and make require admin support true
                mailer = ScheduleInterviewMailer.with(interview: @interview) # trigger mail to admin to create the meeting link.
                mailer.create_custom_link_mail_to_client.deliver_now
                mailer.create_custom_mail_to_candidate.deliver_now
                mailer.create_custom_link_mail_to_admin.deliver_now
                return render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
              end
            end
          rescue Exception => e
            return render json: { errors: e }, status: :unprocessable_entity
          end    
        else
          render json: { errors: "Not belongs to your applied jobs." }
        end
      end
    end

    # Create by PUNIT
    # APi Method for Interview Feedback by interviewer
    def interviewer_feedback
      status = @interview.zoom_meeting.feedback_nofi_status
      return render json: {message: "Link has been Closed"} if status == "block_nofi"
      if @interview.update interviewer_params
        
        client_name = @interview.client.user_full_name
        
        role = @interview.job_description.role.name

        # create_notification
        
        mailer = ScheduleInterviewMailer.with(interview: @interview)
        mailer.feedback_given_by_interviewer.deliver_now
        
        render json: { message: "Feedback Submited" }, status: :ok
      else
        render json: { errors: "Something went wrong" }, status: :unprocessable_entity
      end
    end


    def interviewer_feedback_link
      ScheduleInterviewMailer.with(interview: @interview).interviewer_link.deliver_now
    end

    def interviewers
      interviewers = @current_user.interviewers
      render json: { interviews: interviewers }, status: :ok
    end

    def feedbacks_drop
      feedback = BxBlockScheduling::FeedbackInterview.all.map(&:name)
      render json: { feedback: feedback }, status: :ok
    end

    def get_interview_for_interviewer
      status = @interview.zoom_meeting.feedback_nofi_status
      return render json: {closed_link: "Link has been Closed"} if status == "block_nofi"
      return render json: ScheduleInterviewSerializer.new(@interview).serializable_hash, status: 200
    end
    
    private

    def find_interview_to_token
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken::JsonWebToken.decode(token)
      @interview = ScheduleInterview.find(@token.interview_id)
    end

    def interviews_params
      params.require(:schedule).permit(:account_id, :job_description_id, :role_id, :first_slot, :second_slot,
                                       :third_slot, :require_admin_support, :preferred_slot, :is_accepted_by_candidate, :request_alt_slots,
                                       :interviewer_id, :interview_type, :feedback, :time_zone)
    end

    def client_params
      params.require(:schedule).permit(:first_slot, :second_slot,
                                       :third_slot, :require_admin_support, :feedback, :interviewer_id)
    end

    def interviewer_params
      params.require(:schedule).permit(:feedback, :rating)
    end

    def candidate_params
      params.require(:schedule).permit(:preferred_slot, :is_accepted_by_candidate)
    end

    def find_interview_record
      @interview = ScheduleInterview.find(params[:id])
    end

    def is_feedback_given?
      if @interview.feedback.present? && @interview.rating.present?
        return render json: { message: "Feedback already given." }, status: :unprocessable_entity
      end
    end

    def create_notification
      notification = BxBlockNotifications::Notification.create(
          created_by: @interview.client_id,
          headings: "Please check the Interview Feedback",
          contents: "",
          account_id: @interview.account_id,
          notificable_id: @interview.id,
          notificable_type: "BxBlockScheduling::ScheduleInterview",
          is_read: false,
          notification_type: "check_schedule_interview_feeback"
        )
    end

  end
end
