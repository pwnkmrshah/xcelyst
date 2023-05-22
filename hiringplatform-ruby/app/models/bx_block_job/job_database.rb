module BxBlockJob
  class JobDatabase < ApplicationRecord
    self.table_name = :job_databases

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "job_database_#{Rails.env}"

    settings index: { number_of_shards: 1, max_result_window: 1000000 } do
      mappings dynamic: true do
        indexes :position, type: :nested
      end
    end 

    def as_indexed_json(options = {})
      self.as_json(
        only: [:url, :job_uid, :job_title, :location, :date_published, :business_area, :area_domain, :reference_code, :employment, :responsibilities, :skills, :apply_for_job_url, :description, :company_name, :company_logo, :company_uid]
      )
    end  

    def self.elastic_search(query)
      per_page_limit = BxBlockDatabase::DownloadLimit.last.per_page_limit
      page = (per_page_limit || 5)*(query[:page] || 0).to_i
      must_qry=[]
      s = {
        "from": page,
        "size": per_page_limit || 5,
        "track_total_hits": true,
        "query": {
          "bool": {
            "must": must_qry
          }
        },
        "sort": {
          "date_published": {
            "order": "desc"
          }
        }
      }

      if query[:title].present?
        query[:title].downcase!

        if query[:title].split.any? { |word| ['or', 'and', 'not'].include?(word.downcase) }
          split_or_title = query[:title].split(" or ")
          title_with_and = []
          title_or_qry = []
          title_and_qry = []
          not_qry = []
          split_or_title.each do |word|
            if word.include?("and")
              title_with_and << word
            elsif word.include?("not")
              not_qry << word
            else
              title_or_qry << word
            end
          end

          if title_with_and.present?
            split_and_title = title_with_and.join(", ").gsub(", ", " and ")
            split_and_title = split_and_title.split(" and ")

            split_and_title.each do |word|
              if word.include?("not")
                not_qry << word
              else
                title_and_qry << word
              end
            end
          end

          if not_qry.present?
            not_qry = not_qry.join(', ').split(' not ')
            title_not_qry = not_qry.map { |a| a.gsub("not ", "") }
          end

          or_qry = title_or_qry.map do |word|
            {
              "match_phrase": {
                "job_title": word
              }
            }
          end

          and_qry = title_and_qry.map do |word|
            {
              "match_phrase": {
                "job_title": word
              }
            }
          end

          not_qry = title_not_qry.map do |word|
            {
              "match_phrase": {
                "job_title": word
              }
            } 
          end if title_not_qry.present?

          must_qry << {
            "bool": {
              "must": and_qry
            }
          } if and_qry.any?

          must_qry << {
            "bool": {
              "should": or_qry
            }
          } if or_qry.any?

          if not_qry.present?
            s[:query][:bool][:must_not] ||= []

            not_qry.each do |qry|
              s[:query][:bool][:must_not] << {
                "bool": {
                  "must": qry
                }
              }
            end
          end
        else
          must_qry << {
            "match_phrase": {
              "job_title": query[:title]
            }
          }
        end
        # query[:title].downcase!
        # title = query[:title].split(' or ')
        # qry = []
        # title.each do |word|
        #   qry << {
            #             "match_phrase": {
            #               "job_title": word
            #             }
            #           }
        # end     
        # s[:query][:bool][:must] << {
              #       "bool": {
        #         "should": qry
          #     }
            #   }
      end

      if query[:keywords].present?
        keyword = format_keyword(query[:keywords])
        keywords_or_qry = keyword[:or_qry]
        keywords_and_qry = keyword[:and_qry]
        keywords_not_qry = keyword[:not_qry]
        plain_qry = keyword[:original_arr]

        plain_qry = plain_qry.map do |word|
          {
            "multi_match": {
              "query": word,
              "fields": ["*"],
              "operator": "and",
              "type": "phrase"
            }
          }
        end if plain_qry.present?

        or_qry = keywords_or_qry.map do |word|
          {
            "multi_match": {
              "query": word,
              "fields": ["*"],
              "operator": "and",
              "type": "phrase"
            }
          }
        end if keywords_or_qry.present?

        and_qry = keywords_and_qry.map do |word|
          {
            "multi_match": {
              "query": word,
              "fields": ["*"],
              "operator": "and",
              "type": "phrase"
            }
          }
        end if keywords_and_qry.present?

        not_qry = keywords_not_qry.map do |word|
          {
            "multi_match": {
              "query": word,
              "fields": ["*"],
              "operator": "and",
              "type": "phrase"
            }
          }
        end if keywords_not_qry.present?

        s[:query][:bool][:must] ||= []
        s[:query][:bool][:must] << and_qry if and_qry&.any?
        s[:query][:bool][:must].flatten!

        s[:query][:bool][:should] ||= []
        s[:query][:bool][:should] << or_qry if or_qry&.any?
        s[:query][:bool][:should].flatten!

        s[:query][:bool][:filter] ||= []
        s[:query][:bool][:filter] << plain_qry if plain_qry&.any?
        s[:query][:bool][:filter].flatten!

        if not_qry.present?
          not_qry.each do |qry|
            s[:query][:bool][:must_not] ||= []
            s[:query][:bool][:must_not] << not_qry
          end
          s[:query][:bool][:must_not].flatten!
        end
      end

      if query[:start_date_published].present? && query[:end_date_published].present?
        start_date_published = query[:start_date_published].to_datetime
        end_date_published = query[:end_date_published].to_datetime

        s[:query][:bool][:filter] ||= []
        s[:query][:bool][:filter] << {
          "range": {
            "date_published": {
              "gte": start_date_published,
              "lt": end_date_published
            }
          }
        }
      end

      if query[:location].present?
        query[:location].downcase!
        location_or_qry = query[:location].split(" or ")
        or_qry = location_or_qry.map do |word|
          {
            match_phrase_prefix: {
              location: {
              query: word
              }
            }
          }
        end
          
        s[:query][:bool][:must] << {
                  "bool": {
              "should": or_qry
            }
            }
      end

      if query[:company].present?
        query[:company].downcase!
        company = query[:company].split(' or ')
        qry = []
        company.each do |word|
          qry << {
            "match_phrase": {
              "company_name": word
            }
          }
        end
        s[:query][:bool][:must] << {
          "bool": {
            "should": qry
          }
        }
      end

      if query[:employment_type].present?
        query[:employment_type].downcase!
        employment_type = query[:employment_type]
        s[:query][:bool][:must] << {
          "bool": {
            "should": {
              "match_phrase": {
                "employment": employment_type
              }
            }
          }
        }
      end

      p s[:query]
      self.__elasticsearch__.search(s)
    end

    def self.auto_suggestion(query)
      keyword = query[:key]
      s = {
        from: 0,
        size: 10,
        track_total_hits: true,
        query: {
          bool: {
            filter: []
          }
        },
        _source: [keyword]
      }

      if query[:value].present?
        value = query[:value].split(' or ')
        qry = value.map do |word|
          {
            match_phrase_prefix: {
              "#{keyword}": {
                query: word
              }
            }
          }
        end

        s[:query][:bool][:filter] << {
          bool: {
            should: qry
          }
        }
      end

      response = __elasticsearch__.search(s)
      response = response.response.dig("hits", "hits")&.map { |hit| hit["_source"]["#{keyword}"]}.uniq
      if response.present?
        response&.flatten&.compact&.sort_by do |res|
          [res.split(", ").size, (res.downcase.include?("india")) ? 0 : 1]
        end[0..9]
      end
    end

    def self.format_keyword(arr)
      full_string = arr
      arr = split_keywords(arr)
      or_qry = []
      and_qry = []
      not_qry = []
      original_arr = []
      index = 0
      while index < arr.length
        if arr[index].downcase == "or"
          or_qry << arr[index-1] if index > 0 && arr[index-1] != "and"
          or_qry << arr[index+1] if index < arr.length - 1 && arr[index+1] != "and"
        elsif arr[index].downcase == "and"
          and_qry << arr[index-1] if index > 0 && arr[index-1] != "or"
          and_qry << arr[index+1] if index < arr.length - 1 && arr[index+1] != "or"
        elsif arr[index].downcase == "not"
          not_qry << arr[index+1]
        else
          original_arr << arr[index]
        end
        index += 1
      end

      or1 = or_qry - not_qry
      and1 = and_qry - or_qry
      original_arr = original_arr - or1 - and1 - not_qry
      
      if arr.include?(full_string.gsub("\"", ""))
        and1 = [full_string.gsub("\"", "")]
        original_arr = []
        or1 = []
        not_qry = []
      end
      { or_qry: or1, and_qry: and1, not_qry: not_qry, original_arr: original_arr }
    end

    def self.split_keywords(arr)
      arr = arr.split
      indices = arr.each_index.select { |i| arr[i].include?("\"") }
      pairs = indices.each_slice(2).to_a

      result = []
      start_index = 0
      pairs.each do |pair|
        end_index = pair[0]
        result.concat(arr[start_index..(end_index-1)])
        result << arr[pair[0]..pair[1]].join(' ').delete_prefix('"').delete_suffix('"')
        start_index = pair[1]+1 if pair[1].present?
      end

      result.concat(arr[start_index..])
    end
  end
end
