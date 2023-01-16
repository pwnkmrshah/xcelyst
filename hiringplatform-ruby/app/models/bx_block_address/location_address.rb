module BxBlockAddress
	class LocationAddress < ApplicationRecord
		self.table_name = :location_addresses

		validates_presence_of :country, :address, :email, :phone, :order

		validates_uniqueness_of :order, :email, :phone

		validates :country, format: { with: /^[a-zA-Z ']*$/, message: "Numbers & Special character's are not allowed", :multiline => true }
		validates_format_of :email, 
  			:with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, :multiline => true
		validates_format_of :phone, :with => /^[+0-9 -]*$/, multiline: true
	end
end