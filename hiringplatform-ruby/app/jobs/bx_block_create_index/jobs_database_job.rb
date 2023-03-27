module BxBlockCreateIndex
	class JobsDatabaseJob < BxBlockBulkUpload::ApplicationJob 

		def perform(ids)
            model_to_search = BxBlockJob::JobDatabase
            records = BxBlockJob::JobDatabase.where(id: ids)
            bulk_index(records, model_to_search)
		end

        # def import(model_to_search)
        #     model_to_search.
        #     model_to_search.find_in_batches(batch_size: 500) do |records|
        #     end
        # end

        def prepare_records(records)
            records.map do |record|
                {
                    index: {
                        _id: record.id,
                        data: record.__elasticsearch__.as_indexed_json
                    }
                }
            end
        end

        def bulk_index(records, model)
            model.__elasticsearch__.client.bulk(
                index: model.__elasticsearch__.index_name,
                type: model.__elasticsearch__.document_type,
                body: prepare_records(records)
            )
        end

	end
end
