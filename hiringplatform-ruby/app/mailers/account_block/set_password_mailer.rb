module AccountBlock
  class SetPasswordMailer < ApplicationMailer
    def set_password_email
      if params[:account_id]
        @account = Account.find(params[:account_id])
        @password = params[:pass]
        @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]

        @url = "#{@host}/account_block/accounts_setpassword?token=#{@account.reset_password_token}"
        mail(
            to: @account.email,
            subject: 'Welcome to Xcelyst! Your Account Details Inside.') do |format|
            format.html { render 'set_password_email' } 
        end
      end
    end

    def reset_password
      if params[:account_id]
        @account = Account.find(params[:account_id])
        @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
        @url = "#{@host}/account_block/accounts_setpassword?token=#{@account.reset_password_token}"
        mail(
          to: @account.email,
          subject: 'Password Reset Link for Your Xcelyst Account') do |format|
          format.html { render 'reset_password' } 
      end
      end
    end

    def client_changed_password
      if params[:account_id]
        account = Account.find(params[:account_id])
        host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
        email = "info@xcelyst.com"
        mail(to: email, subject: 'Client password changed successfully', body: "#{account.first_name} #{account.last_name} password changed successfully")
      end
    end
  end
end
