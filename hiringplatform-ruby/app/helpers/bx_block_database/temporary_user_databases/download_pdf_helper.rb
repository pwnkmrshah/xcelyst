module BxBlockDatabase::TemporaryUserDatabases::DownloadPdfHelper

	# created by akash deep
	# to mask the email from 3rd character till before @
	def get_email_records(obj, type)
		data = []
		if obj.present?
			obj.each do |rec|
				if rec['type'] == type
					value = rec['value']
					value[2..(value.length - (value.split('@').last.length+2))] = "*" * (value.split('@').first.length - 2)
					data << value
				end
			end
			return data.join(" , ")
		end
		data
	end

	# created by akash deep
	# to mask the phone no from 4th no till end.
	def get_phone_records(obj, type)
		data = []
		if obj.present?
			obj.each do |rec|
				if rec['type'] == type
					value = rec['value'].delete(' ')
					rand_str = "*" * value[4..value.length].length
					value[4..value.length] = rand_str
					data << value
				end
			end
			return data.join(" , ")
		end
		data
	end

	# created by akash deep
	# convert the time into month and year format
	def convert_time(time)
		if time.present?
			return time.to_date.strftime("%B %Y")
		end
	end

	# created by akash deep
	# calculcate the latest experience.
	def get_years(obj)
		started_date = obj['started'].kind_of?(Hash) ? obj['started']['date'] : obj['started']
		if started_date.present?
			no_of_days = (started_date.to_date..Time.zone.now.to_date).count
			years = no_of_days/365
			days = no_of_days%365
			months = (days/30.5).floor

			return "#{(years > 0) ? "#{years} #{(years > 1) ? 'years' : 'year'}" : nil } #{(months > 0) ? "#{months} #{months > 1 ? 'months' : 'month'}" : nil }"
		else
			return "NA"
		end

		
	end

end