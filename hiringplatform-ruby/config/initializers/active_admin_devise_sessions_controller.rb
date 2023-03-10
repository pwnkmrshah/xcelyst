class ActiveAdmin::Devise::SessionsController
  include ::ActiveAdmin::Devise::Controller
  
  def create
    @otp_valid = false
    @is_valid = false
    @is_required_2fa = false
    @admin_user = UserAdmin.find_by_email(params[:user_admin][:email].presence || session[:user_admin][:email])
    if @admin_user.present? && @admin_user.valid_password?(params[:user_admin][:password].presence || session[:user_admin][:password])
      @is_valid = true
      if @admin_user.enable_2FA
        @is_required_2fa = true
        if params[:user_admin][:otp].blank? && session[:user_admin].blank?
          Admin::UserMailer.two_factor_authentication(@admin_user).deliver 
          session[:user_admin] = {}
          session[:user_admin][:email] = params[:user_admin][:email].presence || session[:user_admin][:email]
          session[:user_admin][:password] = params[:user_admin][:password].presence || session[:user_admin][:password]
        end  
        if params[:user_admin][:otp].present? && params[:user_admin][:otp] == @admin_user.otp.to_s
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
    sign_in(:user_admin, @admin_user)
    @admin_user.update(otp: nil)
    session[:user_admin] = {}
  end
end