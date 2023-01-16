# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create(email: 'admin@xcelyst.com', password: 'password', password_confirmation: 'password') if AdminUser.find_by_email('admin@xcelyst.com').blank?

AccountBlock::UserResume.all.each do |resume|
	resume.account.update(document_id: resume.document_id)
end

BxBlockDatabase::DownloadLimit.create(no_of_downloads: 5) unless BxBlockDatabase::DownloadLimit.first.present?

# AccountBlock::TemporaryAccount.all.each do |temp_acc|
# 	if temp_acc.parsed_resume['Value']['ResumeData']['ResumeMetadata']['ReservedData'].present?
# 		resp = temp_acc.parsed_resume['Value']['ResumeData']['ResumeMetadata']['ReservedData']
# 		if resp['Names'].present?
# 			temp_acc.update first_name: resp['Names'][0]
# 		end
# 	end
# end

schedule_interviews = BxBlockScheduling::ScheduleInterview.where(time_zone: nil)
schedule_interviews.update_all(time_zone: 'Asia/Kolkata')