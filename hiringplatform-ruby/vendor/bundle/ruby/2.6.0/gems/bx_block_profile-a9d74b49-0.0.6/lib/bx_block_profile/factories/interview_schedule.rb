FactoryBot.define do
  factory :interview, class: 'BxBlockCalendar::InterviewSchedule' do
    applied_job_id{nil}
    event_title{"interview#{rand(1_00-9_99)}"}
    event_description{"Job Interview"}
    joinee_name{"FAKE#{rand(1_00-9_99)}"}
    reminder{false}
    invitation_type{"video"}
    schedule_date{Time.at(rand(51.years))}
  end
end

