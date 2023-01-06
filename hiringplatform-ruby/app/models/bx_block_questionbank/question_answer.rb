module BxBlockQuestionbank
    class QuestionAnswer < ApplicationRecord
      self.table_name = :question_answers
      validates :question, :answer, presence: true
    end
  end