FactoryBot.define do
  factory :availability, :class => 'BxBlockAppointmentManagement::Availability' do
    start_time { '10:00 AM' }
    end_time { '10:00 PM' }
    availability_date { DateTime.now.strftime('%d/%m/%y') }
    service_provider { create :email_account }
  end
end
