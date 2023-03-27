namespace :jobs do
  desc "Delete all records and Elasticsearch data for a company ID"
  task delete_all: :environment do
    job_uid = 42278305200

    # Delete records from JobDatabase table
    BxBlockJob::JobDatabase.where(job_uid: job_uid).delete_all

    # Remove data from Elasticsearch index
    client = Elasticsearch::Client.new(hosts: ENV["ELASTICSEARCH_HOST"])
    client.delete_by_query(index: "job_database_development", body: { query: { term: { job_uid: job_uid } } })
  end
end
