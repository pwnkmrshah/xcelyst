module BxBlockRequestdemo
	class RequestDemo < BxBlockRequestdemo::ApplicationRecord
		self.table_name = :request_demos

		validates :first_name, :last_name, :phone_no, :email, :company_name, presence: true
		validates_format_of :first_name, :last_name, :company_name, :with => /^[a-zA-Z\s]*$/, :multiline => true, message: "Number or special character not allowed"
		validates_format_of :phone_no, :with =>  /\d[0-9]\)*\z/ , :message => "Only  number allowed"
	end
end

