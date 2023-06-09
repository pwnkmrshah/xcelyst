module BxBlockLogin
  class AccountAdapter
    include Wisper::Publisher

    def login_account(account_params)
      case account_params.type
      when 'sms_account'
        phone = Phonelib.parse(account_params.full_phone_number).sanitized
        account = AccountBlock::SmsAccount.find_by(
          full_phone_number: phone)
      when 'email_account'
        email = account_params.email.downcase

        account = AccountBlock::EmailAccount
          .where('LOWER(email) = ?', email).first
      when 'social_account'
        account = AccountBlock::SocialAccount.find_by(
          email: account_params.email.downcase,
          unique_auth_id: account_params.unique_auth_id,
          activated: true)
      end

      unless account.present?
        broadcast(:account_not_found)
        return
      end
      
      unless account.activated
        token = BuilderJsonWebToken.encode(account.id, 'app_user')
        broadcast(:not_fully_verify, account, token) if account.authenticate(account_params.password)
      end

      if account.authenticate(account_params.password)
        token = BuilderJsonWebToken.encode(account.id, 'app_user')
        broadcast(:successful_login, account, token)
      else
        broadcast(:failed_login)
      end
    end
  end
end
