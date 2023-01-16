module BxBlockFeedback
  class InterviewFeedbacksController < ApplicationController

    # Create by punit
    # create client feeedback for candidate
    def create
      accepted = params["data"]["accepted"]
      status = accepted ? "accepted" : "rejected"
      appied_job = BxBlockRolesPermissions::AppliedJob.find_by(role_id: params["data"]["role_id"], profile_id: params["data"]["profile_id"])
      return render json: {errors: "Please Give Final Score"}, status: :unprocessable_entity unless appied_job.final_score.present?
      if !appied_job.interview_feedbacks.present?
      begin
        appied_job.update(accepted: accepted, status: status)
        feedbackparas = jsonapi_deserialize(params)
        feedbackparas = feedbackparas.each { |i| i["applied_jobs_id"] = appied_job.id }
        interview_feedback = InterviewFeedback.create!(feedbackparas)
        if interview_feedback.all? { |i| i.persisted? }
          create_notification(interview_feedback, status)
          render json: { interview_feedback: interview_feedback }, status: :created
        else
          render json: { errors: interview_feedback.select(&:invalid?).map { |i| i.errors.full_messages } }, status: :unprocessable_entity
        end
      rescue => e
        render json: {errors: e}, status: :unprocessable_entity
      end
      else
        render json: { errors: "Interview feedback Already created" }, status: :unprocessable_entity
      end
    end

    def show
      if current_user.user_role == "client"
        applied_job = BxBlockRolesPermissions::AppliedJob.find(params[:applied_job_id])
        if applied_job.present?
          render json: {
                   interview_feedback: InterviewFeedbackSerializer.new(applied_job.interview_feedbacks).serializable_hash,
                   candidate_information: CandidateInformationSerializer.new(applied_job).serializable_hash
                 }, status: 200
        else
          render json: { error: "Candidate didn't applied for this Job." }, status: :unprocessable_entity
        end
      else
        render json: { errors: "Not for any user" }, status: :unprocessable_entity
      end
    end


    def create_notification(interview_feedbacks, status)
      feedback = interview_feedbacks.first
      client= feedback.applied_jobs.role.account
      role = feedback.applied_jobs.role.name
      notification = BxBlockNotifications::Notification.create(
          created_by: client.id,
          headings: "Please check the completed Summary Feedback",
          contents: "",
          account_id: feedback.applied_jobs.account.id,
          notificable_id: feedback.id,
          notificable_type: "BxBlockFeedback::InterviewFeedback",
          is_read: false,
          notification_type: "#{status}_feedback_summary_now_avalible"
      )

      # BxBlockTwilio::ChatTwilio.send_whatspp_message(feedback.account, "choose_interview_slot_template")
    end
  end
end
