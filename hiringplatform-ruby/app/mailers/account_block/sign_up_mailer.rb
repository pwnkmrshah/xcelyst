module AccountBlock
    class SignUpMailer < ApplicationMailer
      def sign_up_you
        fetch_email(@record.email)
      end

      def sovren_score
        account = params[:account]
        sovren_score = account.user_resume.sovren_score rescue nil
        if sovren_score && sovren_score > 0
          mail(to: account.email, from: 'info@xcelyst.com', subject: 'Your Sovren Socre. ', body: "Your resume has successfull upload & Sovren score is #{sovren_score}")
        end
      end
   end
end
  