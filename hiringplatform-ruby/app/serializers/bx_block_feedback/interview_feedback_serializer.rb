module BxBlockFeedback
  class InterviewFeedbackSerializer < BuilderBase::BaseSerializer
    attributes *[
      :feedback_parameter_list,
      :rating,
      :comments,
      :applied_jobs_id
    ]
    
  end
end
