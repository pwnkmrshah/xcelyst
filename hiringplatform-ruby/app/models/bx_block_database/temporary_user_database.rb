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

		# Create by Punit 
		# Create the Elatic Search Quary Using the Params and aslo Search form Elastic Search 
		def self.elastic_search(query)
			should = []
			must = []
			filter = []
			per_page_limit = BxBlockDatabase::DownloadLimit.last.per_page_limit
			page = (per_page_limit || 5)*(query[:page] || 0).to_i
			position = query[:title].present? ? (query[:title]) : "*"
			s = {
				"from": page,
  				"size": per_page_limit || 5,
				"track_total_hits": true,
          		"query": {
            		"bool": {
						"should": [
							{
								"nested": {
									"path": "position",
									"query": {
										"bool": {}
									}
								}
							}
						]
					}
				}
			}

			# must << {
			# 	"query_string": {
			# 			"query": "#{position}",
			# 			"default_field": "position.position"
			# 		}
			# 	}
			if query.has_key?(:current)
				must << {
					"query_string": {
						"query": query[:current],
						"default_field": "position.current"
						}
					}
			end
			s[:query][:bool][:should][0][:nested][:query][:bool][:must] = must

			if query[:location].present?
				s[:query][:bool][:must] = [{
											"simple_query_string": {
											  "fields": [ "location" ],
											  "query": "#{query[:location]}"
					    					}
										}]
			end
			if query[:full_name].present?
				s[:query][:bool][:must] = [{
					"match_phrase": {
						"full_name": "#{query[:full_name]}"
					}
				}]
			end
			if query[:company].present?
					s[:query][:bool][:should][0][:nested][:query][:bool][:must] << {
						"query_string": {
						  "query": "#{query[:company]}",
						  "default_field": "position.company"
						}
					}
			end
			if query[:title].present?
				title = query[:title].split(' or ')
				title_or_qry = title.reject{|a|a.include? 'and'}
				rem_title = title.select{|a|a.include? 'and'}.join(' ')
				title_and_qry = rem_title.split(' and ')
				or_qry=[]
				and_qry=[]
				title_or_qry.each do |word|
					or_qry << {
	                    "match_phrase": {
	                      "position.position": word
	                    }
	                  }
				end
				title_and_qry.each do |word|
					and_qry << {
	                    "match_phrase": {
	                      "position.position": word
	                    }
	                  }
				end
				s[:query][:bool][:should][0][:nested][:query][:bool][:must] << {
                		"bool": {
						      "must": and_qry
		    				}
	        	}
				s[:query][:bool][:should][0][:nested][:query][:bool][:must] << {
                	"bool": {
				      "should": or_qry
    				}
	        	}
			end
			if query[:keywords].present?
				unless s[:query][:bool][:must].present?
					s[:query][:bool][:must] = [{
						"multi_match": {
						"query": "#{query[:keywords]}",
						"fields": ["*"],
						"operator": "and"
						}
					}]
				else
					s[:query][:bool][:must] << {
						"multi_match": {
						"query": "#{query[:keywords]}",
						"fields": ["*"]
						}
					}
				end
			end
			if query[:experience].present?
				start = (query[:experience][:started] || 0) * 12
				ended = (query[:experience][:ended] || 99) * 12
				unless s[:query][:bool][:must].present?
					s[:query][:bool][:must] =  [{
						"range": {"experience_month": {"gte": start ,"lte": ended}}
					}]
				else
					s[:query][:bool][:must] << {
						"range": {"experience_month": {"gte": start,"lte": ended}}
					}
				end
			end

			if query.has_key?(:watched) && query.has_key?(:ip_address)
				ids = BxBlockDatabase::WatchedRecord.where(ip_address: query[:ip_address]).pluck(:temporary_user_database_id)
				if query[:watched]
					s[:query][:bool][:filter] = [{
						"ids": {
						  "values": ids
						}}]
				elsif query.has_key?(:ip_address)
					s[:query][:bool][:must_not] = [{
						"ids": {
						  "values": ids
					}}]
				end
			end
			self.__elasticsearch__.search(s)
		end

		# created by punit parmar
		# to show the auto suggestion while user start typing on the screen.
		def self.auto_suggection(query)
			s = self.__elasticsearch__.search({
							"_source": [],
							"size": 0,
							"query": {
								"nested": {
									"path": "position",
									"query": {
										"bool": {
											"must": [
												{
													"wildcard": {
														"position.#{query[:key]}": {
															"value": "#{query[:value]}*" 
													}
													}
												}
											]
										}
									}
								}
							},
						
						"aggs": {
								"positions": {
									"nested": {
										"path": "position"
									},
									"aggs": {
										"auto_complete": {
											"terms": {
												"field": "position.#{query[:key]}.keyword",
												"order": {
														"_count": "desc"
													},
												"size": 10
						
											}
										}
									}
								}
							}
					}).response["aggregations"]["positions"]["auto_complete"]["buckets"]&.map{ |s| s["key"] }
		end
    
	end
end