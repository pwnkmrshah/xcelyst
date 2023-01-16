module BxBlockFeedback
  class InterviewFeedback < ApplicationRecord
    self.table_name = :interview_feedbacks
    belongs_to :applied_jobs, class_name: "BxBlockRolesPermissions::AppliedJob", foreign_key: 'applied_jobs_id'
    belongs_to :feedback_parameter_list, class_name: "BxBlockFeedback::FeedbackParameterList", foreign_key: 'feedback_parameter_lists_id'
  end
end