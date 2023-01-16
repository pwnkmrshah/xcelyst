module AccountBlock
  class EmailAccount < Account
    include Wisper::Publisher
    validates :email, presence: true

    def self.create_stripe_customers(account)
      stripe_customer = Stripe::Customer.create({
        email:  account.email
      })
      account.stripe_id = stripe_customer.id
      account.save
    end

    private

    def self.expire_otp
      Account.where('otp_valid_till < ?', Time.zone.now).update_all(otp: nil, otp_valid_till: nil)
    end

  end
end
