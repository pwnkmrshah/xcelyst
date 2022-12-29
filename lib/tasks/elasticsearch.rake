require 'elasticsearch/model'

namespace :elastic do
    desc 'Update Indexing in elastic search'
    task elatic_index_update: :environment do
        BxBlockDatabase::TemporaryUserDatabase.__elasticsearch__.delete_index! rescue nil
        BxBlockDatabase::TemporaryUserDatabase.__elasticsearch__.create_index!
        BxBlockDatabase::TemporaryUserDatabase.import
    end
end