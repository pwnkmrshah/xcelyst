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
				only: [:url, :job_uid, :job_title, :location, :date_published, :business_area, :area_domain, :reference_code, :employment, :responsibilities, :skills, :apply_for_job_url, :description, :company_name, :company_logo] 
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
							"should": and_qry
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
				# 	qry << {
		        #             "match_phrase": {
		        #               "job_title": word
		        #             }
		        #           }
				# end			
				# s[:query][:bool][:must] << {
	            #     	"bool": {
				# 	      "should": qry
	    		# 		}
		        # 	}
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
				s[:query][:bool][:must] << {
	                	"bool": {
					      "should": qry
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
	end
end


