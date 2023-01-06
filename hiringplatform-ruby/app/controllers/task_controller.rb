class TaskController < ApplicationController

	# created by akash deep
	# to upload the user resume parsed resume data on S3 by creating the file and write all the parse resume field data into that file
	# then upload the file on s3.
	def user_resume_file_upload
		@slot = 0
		@first_rec = AccountBlock::Account.candidates.order('id Asc').first.id  
		@last_rec = AccountBlock::Account.candidates.order('id Asc').last.id
		total_records = AccountBlock::Account.candidates.count
		total_slot = (total_records/100.0).ceil  # calculate the total slots.

		(1..total_slot).each do |slot|
			if slot == 1
				account_ids = AccountBlock::Account.candidates.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@first_rec+99).ids  # pick 100 records in every batch
				@first_rec = @first_rec+100
				ParseFileUploadJob.set(wait: 5.seconds).perform_later('user_resume',account_ids) # send the batch on sidekiq to perform the action.
			elsif total_slot != slot
				account_ids = AccountBlock::Account.candidates.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@first_rec+99).ids
				@first_rec = @first_rec+100
				ParseFileUploadJob.set(wait: slot.minutes).perform_later('user_resume',account_ids)
			elsif total_slot == slot
				account_ids = AccountBlock::Account.candidates.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@last_rec).ids
				ParseFileUploadJob.set(wait: slot.minutes).perform_later('user_resume',account_ids)
			end
		end

		render json: { message: "User Resume File upload processing on backend." }, status: 200
	end

	# created by akash deep
	# to upload the temporary accout parsed resume data on S3 by creating the file and write all the parse resume field data into that file
	# then upload it on s3.
	def temp_account_file_upload
		@slot = 0
		@first_rec = AccountBlock::TemporaryAccount.order('id Asc').first.id
		@last_rec = AccountBlock::TemporaryAccount.order('id Asc').last.id
		total_records = AccountBlock::TemporaryAccount.count
		total_slot = (total_records/100.0).ceil # calculate the total slots.

		(1..total_slot).each do |slot|
			if slot == 1
				temp_account_ids = AccountBlock::TemporaryAccount.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@first_rec+99).ids
				@first_rec = @first_rec+100
				ParseFileUploadJob.set(wait: 5.seconds).perform_later('temp_account',temp_account_ids)
			elsif total_slot != slot
				temp_account_ids = AccountBlock::TemporaryAccount.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@first_rec+99).ids
				@first_rec = @first_rec+100
				ParseFileUploadJob.set(wait: slot.minutes).perform_later('temp_account',temp_account_ids)
			elsif total_slot == slot
				temp_account_ids = AccountBlock::TemporaryAccount.order('id Asc').where('id BETWEEN ? AND ?',@first_rec,@last_rec).ids
				ParseFileUploadJob.set(wait: slot.minutes).perform_later('temp_account',temp_account_ids)
			end
		end

		render json: { message: "Temp Account File upload processing on backend." }, status: 200
	end

end