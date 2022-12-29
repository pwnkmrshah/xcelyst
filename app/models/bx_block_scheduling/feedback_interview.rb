module BxBlockScheduling
  class FeedbackInterview < ApplicationRecord
    self.table_name = :feedback_interviews
    validates :name, presence: true
    validates_format_of :name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"

  end
end
