module BxBlockContactUs
	class ContactMailer < ApplicationMailer
		def contact_us_created(contact)
			@email = "info@xcelyst.com"
			mail(
                to: @email,
                subject: 'User wants to contact.') do |format|
              format.html {render 'contact_us_created'}
            end
        end
    end
end    