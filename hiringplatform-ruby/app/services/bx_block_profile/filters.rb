# Create by Punit
module BxBlockProfile
  class Filters
    def initialize(roles)
      @roles = BxBlockRolesPermissions::RolesSerializer.new(roles).serializable_hash
    end

    def call
      if @roles.present?
        return filters
      end
    end

    def filters
      get_range
      return OpenStruct.new(success?: true, data: [{ filter: "Salary Range", values: @salary_range_arr },
                                                   { filter: "Location", values: @location_range_arr },
                                                   { filter: "Work Level", values: @work_level_arr }])
    end

    # Creating a Filter Response object for Salary, Location and Work Level.
    def get_range
      arr = ["salary_range", "location", "work_level"]
      match = false
      @salary_range_arr = []
      @location_range_arr = []
      @work_level_arr = []
      @roles[:data].map do |role|
        arr.map do |vl|
          match = false
          case vl
          when "salary_range"
            if role[:attributes][:job_description].present? && role[:attributes][:job_description][:minimum_salary].present?
              if @salary_range_arr.present?
                @salary_range_arr.each do |value|
                  if value[:name] == role[:attributes][:job_description][:minimum_salary]
                    value[:vacancy] += 1
                    match = true
                  end
                end
              end
              if !match &&
                 @salary_range_arr << {
                   name: role[:attributes][:job_description][:minimum_salary],
                   vacancy: 1
                 }
              end
            end
          when "location"
            if role[:attributes][:job_description].present? && role[:attributes][:job_description][:location].present?
              if @location_range_arr.present?
                @location_range_arr.each do |value|
                  if value[:name] == role[:attributes][:job_description][:location]
                    value[:vacancy] += 1
                    match = true
                  end
                end
              end
              if !match
                @location_range_arr << {
                  name: role[:attributes][:job_description][:location],
                  vacancy: 1,
                }
              end
            end
          when "work_level"
            if role[:attributes][:job_description].present? && role[:attributes][:job_description][:preferred_overall_experience][:level].present?
              if @work_level_arr.present?
                @work_level_arr.each do |value|
                  if value[:name] == role[:attributes][:job_description][:preferred_overall_experience][:level]
                    value[:vacancy] += 1
                    match = true
                  end
                end
              end
              if !match
                @work_level_arr << {
                  name: role[:attributes][:job_description][:preferred_overall_experience][:level],
                  vacancy: 1,
                }
              end
            end
          end
        end
      end
    end

    # Filtering to Role Using Filter params
    def self.get_filter_role(filter_params, role_ids)
      roles = BxBlockRolesPermissions::Role.where(id: role_ids, is_closed: false)
      job_description = BxBlockJobDescription::JobDescription.where(role_id: role_ids)
      filter_role_ids = []
       filter_params.map do |filter|
        case filter["type"]
        when "Search"
          ids = roles.ransack(name_cont: filter["values"]).result.ids
          filter_role_ids.concat(ids)
        when "Salary Range"
          ids = job_description.where(minimum_salary: filter["values"]).pluck(:role_id) 
          filter_role_ids.concat(ids)
        when "Location"
          ids = job_description.where(location: filter["values"]).pluck(:role_id) 
          filter_role_ids.concat(ids)
        when "Work Level"
          work_level_ids = BxBlockPreferredOverallExperiences::PreferredOverallExperiences.where(level: filter["values"]).ids
          ids = job_description.where(preferred_overall_experience_id: work_level_ids).pluck(:role_id) 
          filter_role_ids.concat(ids)
        end
      end
      filter_role_ids
    end

  end
end
