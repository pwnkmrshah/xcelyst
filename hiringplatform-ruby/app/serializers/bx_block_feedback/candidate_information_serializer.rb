module BxBlockFeedback
	class CandidateInformationSerializer < BuilderBase::BaseSerializer

		attributes :candidate_name do |obj|
			account = obj.profile.account
			"#{account.first_name} #{account.last_name}"
		end

		attributes :candidate_profile do |obj|
			account = obj.profile.account

      host = Rails.application.routes.default_url_options[:host]

      if account.avatar.attached?
      	host+Rails.application.routes.url_helpers.rails_blob_url(account.avatar, only_path: true)
      end
		end

		attributes :job_role do |obj|
			obj.role.name
		end

	end
end