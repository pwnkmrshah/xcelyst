module AccountBlock
  class EmailValidationMailer < ApplicationMailer
    def activation_email
      fetch_email(@record.email)
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 'app_user', 10.minutes.from_now
    end
  end
end
