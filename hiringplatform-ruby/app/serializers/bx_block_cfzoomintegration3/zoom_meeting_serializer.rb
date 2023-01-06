module BxBlockCfzoomintegration3
  class ZoomMeetingSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :id,
      :meeting_urls,
      :candidate_id,
      :client_id,
      :schedule_interview_id 
    ]

    # attributes :schedule_interview do |obj|
    #   BxBlockScheduling::ScheduleInterviewSerializer.new(obj.interview).serializable_hash[:data]
    # end

    attributes :zoom_user do |obj|
      ZoomSerializer.new(obj.zoom).serializable_hash[:data]
    end

    attributes :schedule_date do |obj|
      obj.schedule_date.to_date
    end

    attributes :starting_at do |obj|
      Time.at(obj.starting_at.to_i).utc.strftime("%I:%M %p")
    end

    attributes :ending_at do |obj|
      Time.at(obj.ending_at.to_i).utc.strftime("%I:%M %p")
    end

  end
end
