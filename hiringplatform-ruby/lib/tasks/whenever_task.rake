task delete_otp: :environment do
  Rails.logger.info AccountBlock::EmailAccount.expire_otp
end