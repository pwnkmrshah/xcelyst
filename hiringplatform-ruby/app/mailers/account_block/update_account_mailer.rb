module AccountBlock
    class UpdateAccountMailer < ApplicationMailer
      def update_pic
        @email = params[:email]
        @account = Account.find_by(email: @email)
        mail(to: @email, subject: 'Xcelyst Profile Update') do |format|
          format.html { render 'update_profile' }
        end
      end

      def update_profile
        @email = params[:email]
        @account = Account.find_by(email: @email)
        mail(to: @email, subject: 'Xcelyst Profile Update') do |format|
          format.html { render 'update_profile' }
        end
      end
   end
end
  