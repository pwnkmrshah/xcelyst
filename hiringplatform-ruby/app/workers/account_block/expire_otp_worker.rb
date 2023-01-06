module AccountBlock
	class ExpireOtpWorker
		include Sidekiq::Worker

		# created by akash deep 
		# remove the otp from record once reached the expiration limit.
		def perform(*args)
			accounts = AccountBlock::Account.where('otp_valid_till < ?', Time.zone.now)
			if accounts.present?
				accounts.update_all(otp: nil, otp_valid_till: nil)
			end
		end

	end
end