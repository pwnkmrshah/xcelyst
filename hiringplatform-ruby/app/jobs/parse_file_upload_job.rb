class ParseFileUploadJob < ApplicationJob 
  queue_as :default

  # created by akash deep
  # perform the file creation, writing and uploading action.
  def perform(process, ids)
    if process == "user_resume"
        accounts = AccountBlock::Account.candidates.where(id: ids)
        accounts.each do |account|
        user_resume = account.user_resume
        if user_resume.present?
          parsed_resume = user_resume.parsed_resume
          if parsed_resume.present?
            ParseFileUpload.upload_parsed_json_file parsed_resume, user_resume, 'user-resume' # call the service  where we perform the whole action
          end
        end
      end
    elsif process == "temp_account"
      temp_accounts = AccountBlock::TemporaryAccount.where(id: ids)
      temp_accounts.each do |temp_account|
        parsed_resume = temp_account.parsed_resume
        if parsed_resume.present?
          ParseFileUpload.upload_parsed_json_file parsed_resume, temp_account, 'temp-account' # call the service  where we perform the whole action
        end
      end
    end
  end
  
end
