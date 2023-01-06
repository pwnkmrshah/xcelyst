module BxBlockFeedback
    class FeedbackParameterList < ApplicationRecord
        self.table_name = :feedback_parameter_lists
        validates :name, presence: true
        validates_format_of :name, :with => /^[a-zA-Z0-9\s]*$/, :multiline => true, message: "special character not allowed"
    end
end