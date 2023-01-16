require "elasticsearch/model"
module Searchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    ngram_filter = { type: 'nGram', min_gram: 2, max_gram: 20 }
    ngram_analyzer = {
      type: 'custom',
      tokenizer: 'standard',
      filter: %w[lowercase asciifolding ngram_filter]
    }
    whitespace_analyzer = {
      type: 'custom',
      tokenizer: 'whitespace',
      filter: %w[lowercase asciifolding]
    }
    
    # inside the included block
    settings analysis: {
      filter: {
        ngram_filter: ngram_filter
      },
      analyzer: {
        ngram_analyzer: ngram_analyzer,
        whitespace_analyzer: whitespace_analyzer
      }
    }
  end
end