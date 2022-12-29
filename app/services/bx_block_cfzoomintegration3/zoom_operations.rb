require 'net/http'
require 'json'
require 'uri'
module BxBlockCfzoomintegration3
	class ZoomOperations

		attr_accessor :api_key, :api_secret, :token, :zoom_url

		# created by akash deep
		# to load the value of attr_accessor fields at the time of initilization.
		def initialize
			@api_key = ENV['ZOOM_API_KEY'] || "z0HkJn7gQdKsjI0N_QBcKQ"
			@api_secret = ENV['ZOOM_API_SECRET'] || "6gxpy8oJ17bts6MVra1NukJwCpxW4HpFbciN"
			payload = {
				iss: @api_key,
				exp: 1.hour.from_now.to_i
			}
			header = {
				"alg": "HS256",
				"typ": "JWT"
			}
			@token = JWT.encode(payload, @api_secret, 'HS256', { typ: 'JWT' })
			@zoom_url = "https://api.zoom.us/v2/users".freeze
		end

		# created by akash deep
		# to get the list of all users present in provided zoom account.
		def get_zoom_users		
			url = URI("#{zoom_url}")
			
			x = create_uri url,"Get"

			res = x.http.request(x.request)
			res = JSON.parse(res.body)

			if res['code'].present? && res['message'].present?
				OpenStruct.new(success?: false, message: res['message'] )
			elsif	res['users'].present?
				create_zoom_user_record res['users'] 
				message = @count > 0 ? "#{@count} User Has been Synced." : "No new users are found."
				OpenStruct.new(success?: true, message: message )
			else
				OpenStruct.new(success?: true, message: "No User Present." )
			end
		end

		# created by akash deep
		# to create the zoom meeting link for candidate interview.
		def create_meeting_urls params, interview
			check_slot_availability params[:start_time]

			if @zoom_rec.present?
				url = URI("#{zoom_url}/#{@zoom_rec.zoom_user_id}/meetings")

				x = create_uri url,"Post"

				x.request.body = params.to_json

				res = x.http.request(x.request)
				res = JSON.parse(res.body)

				if res["start_url"].present?
					zoom_meeting = ZoomMeeting.new(zoom_id: @zoom_rec.id, client_id: interview.client_id, candidate_id: interview.account_id,
						schedule_date:  @date, starting_at: @start_time, ending_at: @end_time, meeting_urls: { start_url: res['start_url'],
						join_url: res['join_url'] }, provider: 'zoom', schedule_interview_id: interview.id )
					if zoom_meeting.save! 
						OpenStruct.new(success?: true, data: zoom_meeting)
					else
						OpenStruct.new(success?: false, message: zoom_meeting.errors.full_messages )
					end
				else
					OpenStruct.new(success?: false, message: res['message'] )
				end
			else
				OpenStruct.new(success?: false, message: "There is no available slot at this time." )
			end
		end

		private 

		# created by akash deep
		# common method to make the external api call.
		def create_uri url, method
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			request = "Net::HTTP::#{method}".constantize.new(url)
			request["authorization"] = "Bearer #{token}"
			request["content-type"] = 'application/json'

			return OpenStruct.new(request: request, http: http)
		end

		# created by akash deep
		# create the record in zooms table from fetching zoom user data present in provided zoom account.
		def create_zoom_user_record users 
			@count = 0
			user_id_arr = []
			users.each do |user|
				zoom_user = Zoom.find_by(zoom_user_id: user['id'])
				user_id_arr << zoom_user.id if zoom_user.present?
				unless zoom_user.present?
					zoom_user = Zoom.new(zoom_user_id: user['id'], email: user['email'], first_name: user['first_name'], last_name: user['last_name'], status: user['status'])
					@count += 1 if zoom_user.save
					user_id_arr << zoom_user.id
				end
			end
			find_difference_in_records user_id_arr
		end

		# created by akash deep
		# check whether any record is extra which is no more present in our provided zoom account.
		# if any record found for the same destroy those records from the database
		def find_difference_in_records user_id_arr
			unless Zoom.count == user_id_arr.count 
				all_user_id_arr = Zoom.ids 
				ids_arr = all_user_id_arr - user_id_arr
				destroy_other_users(ids_arr) if ids_arr.present?
			end	
		end

		def destroy_other_users ids
			Zoom.where(id: ids).destroy_all
		end

		# created by akash deep
		# check which zoom user account not in use by the given time for any zoom meeting.
		def check_slot_availability start_time
			@zoom_rec = ""
			@date = start_time.to_date 
			@start_time = Time.parse(start_time.to_datetime.to_s(:time)).seconds_since_midnight.to_s  # convert this e.g. "16:30" into seconds
			@end_time = Time.parse("#{start_time.to_datetime.hour+1}:#{start_time.to_datetime.minute}").seconds_since_midnight.to_s   # convert this e.g. "17:30" into seconds
			Zoom.all.each do |zoom_rec|
				@meetings = zoom_rec.zoom_meetings.where(schedule_date: @date, provider: 'zoom')
				@meetings = @meetings.where('starting_at BETWEEN ? AND ? OR ending_at BETWEEN ? AND ?', @start_time, @end_time, @start_time, @end_time)
				if @meetings.blank?
					@zoom_rec = zoom_rec
					break
				end
			end
		end

	end
end
