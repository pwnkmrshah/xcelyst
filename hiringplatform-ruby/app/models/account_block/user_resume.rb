module AccountBlock
  class UserResume < ApplicationRecord
    self.table_name = :user_resumes

    has_one_attached :parse_resume, dependent: :destroy

    belongs_to :account, class_name: "AccountBlock::Account", foreign_key: "account_id"

    validates_uniqueness_of :resume_id, presence: true

    after_create :update_document_id

    def update_document_id
      self.update_columns(index_id: "INDEX" + self.id.to_s, document_id: "#{self.account.first_name}" + self.id.to_s + self.account.id.to_s)
      self.account.update_columns(document_id: self.document_id)
    end

    def get_parsed_resume_data 
      if self.parse_resume.present?
        if self.parse_resume.attached?
          data = [
            Thread.new {
              url = self.parse_resume.service_url
              response = URI.open(url)
              response_data = response.read
              eval(response_data)
            }
          ].map(&:value)
          data[0]
        end  
      end  
    end

  end
end
