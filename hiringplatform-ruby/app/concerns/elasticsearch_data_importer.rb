module ElasticsearchDataImporter
    def self.import
      [BxBlockDatabase::TemporaryUserDatabase, BxBlockJob::JobDatabase].each do |model_to_search|
        model_to_search.__elasticsearch__.create_index!(force: true)
        model_to_search.find_in_batches(batch_size: 200) do |records|
          bulk_index(records, model_to_search)
          sleep 5
        end
      end
    end
    def self.prepare_records(records)
      records.map do |record|
        {
          index: {
            _id: record.id,
            data: record.__elasticsearch__.as_indexed_json
          }
        }
      end
    end
    def self.bulk_index(records, model)
      model.__elasticsearch__.client.bulk(
        index: model.__elasticsearch__.index_name,
        type: model.__elasticsearch__.document_type,
        body: prepare_records(records)
      )
    end
  end