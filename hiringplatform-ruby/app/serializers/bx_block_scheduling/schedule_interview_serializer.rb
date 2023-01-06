module BxBlockScheduling
 	class ScheduleInterviewSerializer < BuilderBase::BaseSerializer
 		
    attributes *[
      :id,
      :first_slot,
      :second_slot,
      :third_slot,
      :rating,
      :require_admin_support,
      :preferred_slot,
      :is_accepted_by_candidate,
      :request_alt_slots,
      :interview_type,
      :interviewer,
      :feedback,
    ]

    attribute :candidate do |obj|
      AccountBlock::EmailAccountSerializer.new(obj.candidate).serializable_hash[:data]
    end

    attribute :interviewer_name do |obj|
      obj.interviewer.name
    end
    
    attributes :client do |obj|
      AccountBlock::EmailAccountSerializer.new(obj.client).serializable_hash[:data]
    end

    attribute :job_description do |obj|
      BxBlockJobDescription::JDSerializer.new(obj.job_description).serializable_hash[:data]
    end

    attribute :role do |obj|
      BxBlockRolesPermissions::RolesSerializer.new(obj.role).serializable_hash[:data]
    end

    attribute :zoom_meeting do |obj|
      BxBlockCfzoomintegration3::ZoomMeetingSerializer.new(obj.zoom_meeting).serializable_hash[:data]
    end

 	end
end