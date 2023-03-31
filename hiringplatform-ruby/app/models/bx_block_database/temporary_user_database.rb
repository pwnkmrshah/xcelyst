module BxBlockDatabase
	class TemporaryUserDatabase < ApplicationRecord
		include Elasticsearch::Model
		include Elasticsearch::Model::Callbacks

		self.table_name = :temporary_user_databases 
		
		# paginates_per 5
		has_many :download_pdfs, class_name: "BxBlockDatabase::DownloadPdf", dependent: :destroy
		has_one :temporary_user_profile, class_name: 'BxBlockDatabase::TemporaryUserProfile', dependent: :destroy
		has_many :watched_records, class_name: "BxBlockDatabase::WatchedRecord", dependent: :destroy

		index_name "user_database_#{Rails.env}"

		# Create by Punit 
		# to create the Mapping the database 
		settings index: { number_of_shards: 1, max_result_window: 1000000 } do
			mappings dynamic: true do
			  indexes :position, type: :nested
			end
		end

		# created by punit parmar
		# to indexed the table fields inside the elastic search cluster
		# that makes the search more fast on the basis of indexing.
		def as_indexed_json(options = {})
			self.as_json(
				only: [:id, :full_name, :title, :zipcode, :city, :status, :ready_to_move, :name, :location, :experience, :company, :previous_work, :skills, :degree, :job_projects, :position, :experience_month],
				include: {
					temporary_user_profile: {
							only: [:skills, :courses, :certificates, :work_experience, :languages, :education, :organizations]
					},
					watched_records: {
							only: [:temporary_user_database_id, :ip_address]
					}
				}
			)
		end  

		# Create by Nishu
		# Create the Elatic Search Quary Using the Params and aslo Search form Elastic Search 
		def self.elastic_search(query)
			nested_must = []
			per_page_limit = BxBlockDatabase::DownloadLimit.last.per_page_limit
			page = (per_page_limit || 5)*(query[:page] || 0).to_i
			position = query[:title].present? ? (query[:title]) : "*"
			s = {
				"from": page,
  				"size": per_page_limit || 5,
				"track_total_hits": true,
          		"query": {
            		"bool": {
						"filter": [{
							"nested": {
								"path": "position",
								"query": {
									"bool": {
										"must": nested_must
									}
								}
							}
						}]
					}
				}
			}
			if query.has_key?(:current)
				current_filter = {
					"query_string": {
						"query": query[:current],
						"default_field": "position.current"
						}
					}
				nested_must << current_filter
			end

			if query[:location].present?
				query[:location].downcase!
				location = query[:location].split(' or ')
				qry = []
				location.each do |word|
					qry << {
		                    "match_phrase": {
		                      "location": word
		                    }
		                  }
				end
				s[:query][:bool][:filter] << {
                	"bool": {
				      "should": qry
    				}
	        	}
			end
			if query[:full_name].present?
				s[:query][:bool][:must] = [{
					"match_phrase": {
						"full_name": "#{query[:full_name]}"
					}
				}]
			end
			if query[:company].present?
				query[:company].downcase!
				company = query[:company].split(' or ')
				qry = []
				company.each do |word|
					qry << {
		                    "match_phrase": {
		                      "position.company": word
		                    }
		                  }
				end
				nested_must << {
					"bool": {
						"should": qry
					}
				} if qry.any?
			end

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
						    "position.position": word
						  }
						}
					end

					and_qry = title_and_qry.map do |word|
						{
						  "match_phrase": {
						    "position.position": word
						  }
						}
					end

					not_qry = title_not_qry.map do |word|
						{
						  "match_phrase": {
						    "position.position": word
						  }
						} 
					end if title_not_qry.present?

					nested_must << {
						"bool": {
							"should": and_qry
						}
					} if and_qry.any?
				    
				    nested_must << {
						"bool": {
							"should": or_qry
						}
					} if or_qry.any?
				    
					if not_qry.present?
						s[:query][:bool][:must_not] ||= []

						not_qry.each do |qry|
							s[:query][:bool][:must_not] << {
								"nested": {
									"path": "position",
									"query": {
										"bool": {
											"must": current_filter.present? ? [ qry, current_filter ] : qry
										}
									}
								}
							}
						end
					end
				else
					nested_must << {
					  "match_phrase": {
					    "position.position": query[:title]
					  }
					}
				end
			end
			if query[:keywords].present?
				keyword = format_keyword(query[:keywords])
				keywords_or_qry = keyword[:or_qry]
				keywords_and_qry = keyword[:and_qry]
				keywords_not_qry = keyword[:not_qry]
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
				s[:query][:bool][:filter] ||= []
				s[:query][:bool][:filter] << or_qry if or_qry&.any?
				s[:query][:bool][:filter] << and_qry if and_qry&.any?
				s[:query][:bool][:filter].flatten!

				if not_qry.present?
					not_qry.each do |qry|
						s[:query][:bool][:must_not] ||= []
						s[:query][:bool][:must_not] << not_qry
					end
					s[:query][:bool][:must_not].flatten!
				end
			end

			if query[:experience].present?
				start = (query[:experience][:started] || 0) * 12
				ended = (query[:experience][:ended] || 99) * 12
				s[:query][:bool][:filter] << {
					"range": {"experience_month": {"gte": start,"lte": ended}}
				}
			end

			if query.has_key?(:watched) && query.has_key?(:ip_address)
				ids = BxBlockDatabase::WatchedRecord.where(ip_address: query[:ip_address]).pluck(:temporary_user_database_id)
				if query[:watched]
					s[:query][:bool][:filter] << {
						"ids": {
						  "values": ids
						}}
				elsif query.has_key?(:ip_address)
					s[:query][:bool][:must_not] = [{
						"ids": {
						  "values": ids
					}}]
				end
			end

			nested_must.flatten!
			p s[:query]
			self.__elasticsearch__.search(s)
		end

		def self.format_keyword(arr)
			arr = split_keywords(arr)
			or_qry = []
			and_qry = []
			not_qry = []

			index = 0
			while index < arr.length
				if arr[index] == "or"
					or_qry << arr[index-1] if index > 0 && arr[index-1] != "and"
					or_qry << arr[index+1] if index < arr.length - 1 && arr[index+1] != "and"
				elsif arr[index] == "and"
					and_qry << arr[index-1] if index > 0 && arr[index-1] != "or"
					and_qry << arr[index+1] if index < arr.length - 1 && arr[index+1] != "or"
				elsif arr[index] == "not"
					not_qry << arr[index+1]
				else
					or_qry << arr[index]
				end
				index += 1
			end
			or1 = or_qry - not_qry
			and1 = and_qry - or_qry
			{ or_qry: or1, and_qry: and1, not_qry: not_qry  }
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
		
		# created by punit parmar
		# to show the auto suggestion while user start typing on the screen.
		def self.auto_suggection(query)
			if query[:key] == "location"
			    s = {
			      from: 0,
			      size: 1000,
			      track_total_hits: true,
			      query: {
			        bool: {
			          filter: []
			        }
			      },
			      _source: ["location"]
			    }

			    if query[:value].present?
					location = query[:value].split(' or ')
					qry = location.map do |word|
						{
						  match_phrase_prefix: {
						    location: {
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
			    locations = response.response.dig("hits", "hits")&.map { |hit| hit["_source"]["location"]&.dig(0) }.uniq
			    if locations.present?
				    locations&.flatten&.sort_by do |location|
				    	[location.split(", ").size, (location.downcase.include?("united")) ? 0 : 1]
					end[0..9]
				end
			else
				s = {
				  from: 0,
				  size: 10,
				  track_total_hits: true,
				  query: {
				    nested: {
				      path: "position",
				      query: {
				        bool: {
				          filter: []
				        }
				      }
				    }
				  },
				  _source: []
				}

				if query[:value].present?
				  data = query[:value].split(' or ')
				  qry = data.map do |word|
				    {
				      match_phrase_prefix: {
				        "position.#{query[:key]}": {
				          query: word
				        }
				      }
				    }
				  end
				  s[:query][:nested][:query][:bool][:filter] = qry
				else
				  # Add a match_all query to retrieve all records
				  s[:query][:nested][:query][:bool][:filter] = [{ match_all: {} }]
				end

				response = __elasticsearch__.search(s)

				hits = response.response.dig("hits", "hits")
				matching_companies = hits.map { |hit| hit.dig("_source", "position") }.flatten.map { |p| p["#{query[:key]}"] }.uniq
				if data.present?
					qry_response = data&.map do |string|
					  matching_companies.select { |str| str&.match?(/#{Regexp.escape(string)}/i) }
					end
					qry_response&.flatten
				else
					matching_companies&.flatten
				end
			end
		end
	end
end