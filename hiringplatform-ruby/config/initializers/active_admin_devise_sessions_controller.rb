class ActiveAdmin::Devise::SessionsController
  include ::ActiveAdmin::Devise::Controller
  
  def create
    @otp_valid = false
    @is_valid = false
    @is_required_2fa = false
    @admin_user = AdminUser.find_by_email(params[:admin_user][:email].presence || session[:admin_user][:email])
    if @admin_user.present? && @admin_user.valid_password?(params[:admin_user][:password].presence || session[:admin_user][:password])
      @is_valid = true
      if @admin_user.enable_2FA
        @is_required_2fa = true
        if params[:admin_user][:otp].blank?
          Admin::UserMailer.two_factor_authentication(@admin_user).deliver 
          session[:admin_user] = {}
          session[:admin_user][:email] = params[:admin_user][:email]
          session[:admin_user][:password] = params[:admin_user][:password]
        end  
        if params[:admin_user][:otp].present? && params[:admin_user][:otp] == @admin_user.otp.to_s
          @otp_valid = true
          login
        end
      else
        login
      end
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def login
    set_flash_message(:notice, :signed_in)
    sign_in(:admin_user, @admin_user)
    @admin_user.update(otp: nil)
    session[:admin_user] = {}
  end
end