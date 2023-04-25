module BxBlockJob
  class JobDatabaseController < ApplicationController
    include ElasticsearchDataImporter

    def create
      job_database = BxBlockJob::JobDatabase.elastic_search(params)  
      options = {params: {ip_address: params[:ip_address]}}
      data = JobDatabaseSerializer.new(job_database.records.to_a, options).serializable_hash[:data]
      render json: {data: data, meta: pagination_data(job_database.results)}, status: :ok
    end

    def index
      job_database = BxBlockJob::JobDatabase.order(:full_name).page(params[:page])
      if job_database.present?
        render json:
          JobDatabaseSerializer.new(job_database, meta: pagination_data(job_database)
          ), status: 200
      else
        render json: { message: "Record not found", meta: pagination_data(job_database)
          }, status: 200
      end
    end

    def suggestions
      if params.has_key?(:location)
        query = {"key": "location", "value": params[:location].downcase}
      elsif params.has_key?(:title)
        query = {"key": "job_title", "value": params[:title].downcase}
      elsif params.has_key?(:company)
        query = {"key": "company_name", "value": params[:company].downcase}
      end

      response = JobDatabase.auto_suggestion(query)
      render json: {sugg: response}, status: :ok
    end

    def pagination_data data
      per_page_limit = BxBlockDatabase::DownloadLimit.last.per_page_limit
      total_data = data.total > 10000 ? data.total : 10000
      total_pages = total_data/(per_page_limit || 5)
      pages = total_data % (per_page_limit || 5)
      if pages > 0
        total_pages += 1
      end
      if total_pages == 0
        total_pages = 1
      end
      {
        total_record: total_data,
        limit_value: per_page_limit,
        total_pages:  total_pages,
        current_page: params[:page],
        next_page: params[:page] + 1,
        prev_page: params[:page] - 1,
        is_first_page: data.first_page?,
        is_last_page: data.last_page?,
        is_out_of_range: data.out_of_range?
      }
    end
  end
end
