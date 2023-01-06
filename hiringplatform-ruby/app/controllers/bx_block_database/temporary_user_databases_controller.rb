module BxBlockDatabase
	class TemporaryUserDatabasesController < ApplicationController
		include ElasticsearchDataImporter
		before_action :check_download_limit, only: :download_pdf

		# Create by Punit 
		# Search the data form Elatic Search 
		def create
			user_database = TemporaryUserDatabase.elastic_search(params)	
			options = {params: {ip_address: params[:ip_address]}}
			data = TemporaryUserDatabaseSerializer.new(user_database.records.to_a, options).serializable_hash[:data]
			render json: {data: data, meta: pagination_data(user_database.results)}, status: :ok
		end

		# Create by Punit 
		# Get the Suggection for Search Data
		def suggectiones
			# {{url}}/bx_block_database/suggectiones?company=tata
			if params.has_key?(:location)
				query = {"key": "location", "value": params[:location].downcase}
			elsif params.has_key?(:title)
				query = {"key": "position", "value": params[:title].downcase}
			elsif params.has_key?(:company)
				query = {"key": "company", "value": params[:company].downcase}
			end
			response = TemporaryUserDatabase.auto_suggection(query)
			render json: {sugg: response}, status: :ok
		end

		def index
			user_database = TemporaryUserDatabase.order(:full_name).page(params[:page])
			if user_database.present?
				render json:
					TemporaryUserDatabaseSerializer.new(user_database, meta: pagination_data(user_database)
					), status: 200
			else
				render json: { message: "Record not found", meta: pagination_data(user_database)
					}, status: 200
			end
		end

		# Create by Punit
		# Create the Indexes for Temporary User Database. This Method only Developer User
		def create_index
			begin
				slot = 0
				BxBlockDatabase::TemporaryUserDatabase.__elasticsearch__.create_index!(force: true)
				first_rec = BxBlockDatabase::TemporaryUserDatabase.order('id Asc').first.id
				last_rec = BxBlockDatabase::TemporaryUserDatabase.order('id Asc').last.id
				total_records = BxBlockDatabase::TemporaryUserDatabase.count
				total_slot = (total_records/1000.0).ceil
				
				(1..total_slot).each do |slot|
					if slot == 1
						records = BxBlockDatabase::TemporaryUserDatabase.order('id Asc').where('id BETWEEN ? AND ?',first_rec,first_rec+999).ids
						first_rec = first_rec+1000
						BxBlockCreateIndex::DatabaseUserJob.set(wait: 30.seconds).perform_later(records)
					elsif total_slot != slot
						records = BxBlockDatabase::TemporaryUserDatabase.order('id Asc').where('id BETWEEN ? AND ?',first_rec, first_rec+999).ids
						first_rec = first_rec+1000
						BxBlockCreateIndex::DatabaseUserJob.set(wait: (slot*5.minutes).seconds).perform_later(records)
					elsif total_slot == slot
						records = BxBlockDatabase::TemporaryUserDatabase.order('id Asc').where('id BETWEEN ? AND ?',first_rec, last_rec).ids
						BxBlockCreateIndex::DatabaseUserJob.set(wait: (slot*5.minutes).seconds).perform_later(records)
					end
				end
				render json: {message: "created successfull index"}, status: :ok
			rescue => exception
				render json: {errors: exception}, status: :ok
			end
		end
		
		def pagination_data data
			total_data = data.total > 10000 ? 10000 : data.total
			total_pages = total_data/5
			if total_pages == 0
				total_pages = 1
			end
			{
				total_record: total_data,
				limit_value: data.limit_value,
				total_pages:  total_pages,
				current_page: params[:page],
				next_page: params[:page] + 1,
				prev_page: params[:page] - 1,
				is_first_page: data.first_page?,
				is_last_page: data.last_page?,
				is_out_of_range: data.out_of_range?
			}
		end

		def download_pdf
			download = DownloadPdf.new(temporary_user_database_id: @user_record.id, ip_address: @ip_address, download_on: Time.zone.now)
			if download.save
				respond_to do |format|
          format.html
          format.pdf do
            render pdf: "#{@user_record.present? ? @user_record.full_name : "file_name"}",
            page_size: 'A4',
            template: "bx_block_database/temporary_user_databases/download_pdf.html.erb",
            orientation: "portrait",
            lowquality: true,
            zoom: 1,
            dpi: 75
          end
        end
    		# pdf_html = ''
    		# pdf_html += ApplicationController.new.render_to_string(partial: 'bx_block_database/temporary_user_databases/download_pdf', layout: false, formats: [:html], locals: { user_record: @user_record})
		    # pdf = WickedPdf.new.pdf_from_string(pdf_html)
		    # send_data pdf, filename: "#{@user_record.present? ? "#{@user_record.full_name}.pdf" : "resume.pdf"}"
			end
		end

		private

		def check_download_limit
			@user_record = TemporaryUserDatabase.find(params[:id])
			@ip_address = request.ip
			time = Time.zone.now
			downloads = DownloadPdf.where(ip_address: @ip_address, download_on: time.beginning_of_day..time.end_of_day)
			if downloads.count >= DownloadLimit.first.no_of_downloads
				return render json: { message: "You may exceed the daily download's limit." }, status: 422
			end
		end

	end
end
