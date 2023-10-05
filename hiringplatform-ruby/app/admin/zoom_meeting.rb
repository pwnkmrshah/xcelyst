ActiveAdmin.register BxBlockCfzoomintegration3::ZoomMeeting, as: "Zoom Meeting" do
	permit_params :client_id, :candidate_id, :zoom_id, :schedule_date, :starting_at, :meeting_urls
  batch_action :destroy, if: proc { current_user_admin.batch_action_permission_enabled?('zoom meeting') }, confirm: "Are you sure want to delete selected items?" do |ids|
    module_name = scoped_collection.name.split("::").last
    module_name = module_name.gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    scoped_collection.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{module_name}."
  end

	actions :index, :show, :new

	index do
		selectable_column
		id_column
		column :client_id do |obj|
			link_to("#{obj.client.first_name} #{obj.client.last_name}", admin_client_path(obj.client_id))
		end
		column :candidate_id do |obj|
			link_to("#{obj.candidate.first_name} #{obj.candidate.last_name}", admin_candidate_path(obj.candidate_id))
		end
		column :interview_role do |obj|
			if obj.interview.present?
				obj.interview.role.name
			end
		end
		column :schedule_date do |obj|
			obj.schedule_date.to_date
		end
		column :starting_at do |obj|
			Time.at(obj.starting_at.to_i).utc.strftime("%I:%M %p")
		end
		actions
	end

	filter :client_id, :as => :select, :collection => proc { AccountBlock::Account.clients.collect { |o| [o.first_name, o.id] } }
  filter :candidate_id, :as => :select, :collection => proc { AccountBlock::Account.candidates.collect { |o| [o.first_name, o.id] } }
  filter :schedule_date

	show do
    attributes_table do
      row :client_id do |obj|
				link_to("#{obj.client.first_name} #{obj.client.last_name}", admin_client_path(obj.client_id))
			end
      row :candidate_id do |obj|
				link_to("#{obj.candidate.first_name} #{obj.candidate.last_name}", admin_candidate_path(obj.candidate_id))
			end
			row :interview_role do |obj|
				if obj.interview.present?
					obj.interview.role.name
				end
			end
			row :provider do |obj|
				if obj.provider.present?
					obj.provider.tr("_", " ").titleize
				end
			end
			row :zoom_user do |obj|
				if obj.zoom_id.present?
					link_to(obj.zoom.email, admin_zoom_user_path(obj.zoom_id))
				end
			end

      row :schedule_date do |obj|
				obj.schedule_date.to_date
			end
      row :starting_at do |obj|
				Time.at(obj.starting_at.to_i).utc.strftime("%I:%M %p")
			end
      row :ending_at do |obj|
				Time.at(obj.ending_at.to_i).utc.strftime("%I:%M %p")
			end
      row :join_url do |obj|
      	if obj.meeting_urls['join_url'].present?
        	link_to('Join Now', obj.meeting_urls['join_url'], target: "_blank", class: 'button' )
        end
      end
      row :start_url do |obj|
      	if obj.meeting_urls['start_url'].present?
        	link_to('Start Now', obj.meeting_urls['start_url'], target: '_blank', class: 'button' )
        end
      end
      row :updated_at
      row :created_at
    end 
  end

	form do |f|
    f.inputs do
    	f.semantic_errors *f.object.errors.keys
      f.input :client_id, as: :select, collection: AccountBlock::Account.clients.collect {|o| [o.first_name, o.id]}
      f.input :candidate_id, as: :select, collection: AccountBlock::Account.candidates.collect {|o| [o.first_name, o.id]}
      f.input :schedule_interview_id, as: :select, collection: []
      f.input :provider, as: :select, collection: ["zoom", "google_meet", "teams"]
      f.input :zoom_id, as: :select, collection: BxBlockCfzoomintegration3::Zoom.all.collect { |o| [o.first_name, o.id] }
      f.input :schedule_date, :as => :datepicker, datepicker_options: { min_date: Time.zone.now.to_date }
      f.input :starting_at, as: :time_picker, placeholder: 'Use 24 Hours Format'
      f.input :meeting_urls, as: :string
    end
    f.actions
	end

	controller do 

		def create
			param = params[:bx_block_cfzoomintegration3_zoom_meeting]
			if param['meeting_urls'].include?(param['provider'].split('_').first)
				@interview = BxBlockScheduling::ScheduleInterview.find(param['schedule_interview_id'])
				if @interview.present?
					date = param['schedule_date'].to_date 
					start_time = param['starting_at']
					starting_at = Time.parse(start_time).seconds_since_midnight.to_s if start_time.present?
					ending_at = Time.parse("#{start_time.to_datetime.hour+1}:#{start_time.to_datetime.minute}").seconds_since_midnight.to_s if start_time.present?

					zoom_meeting = @interview.build_zoom_meeting(zoom_id: param['zoom_id'], client_id: param['client_id'], candidate_id: param['candidate_id'],
						schedule_date:  date, starting_at: starting_at, ending_at: ending_at, meeting_urls: { start_url: param['meeting_urls'] },
						provider: param['provider'])

					if zoom_meeting.save
						mailer = BxBlockScheduling::ScheduleInterviewMailer.with(interview: @interview)
            mailer.choose_interview_to_candidate.deliver_now
            mailer.meeting_schedule_from_admin_to_client.deliver_now 
            mailer.choose_interview_to_interviewer.deliver_now
						redirect_to admin_zoom_meetings_path 
					else
						flash[:alert] = zoom_meeting.errors.full_messages
						redirect_to new_admin_zoom_meeting_path
					end
				else
					flash[:alert] = "Schedule Interview record not present."
					redirect_to new_admin_zoom_meeting_path
				end
			else
				flash[:alert] = "Provider doesn't match with meeting url."
				redirect_to new_admin_zoom_meeting_path
			end
		end


	end

end   