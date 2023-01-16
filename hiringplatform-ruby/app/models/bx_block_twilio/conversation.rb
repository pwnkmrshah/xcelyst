module BxBlockTwilio
  class Conversation < ApplicationRecord
    self.table_name = :conversations
    belongs_to :client, class_name: "AccountBlock::Account", foreign_key: "client_id"
    belongs_to :candidate, class_name: "AccountBlock::Account", foreign_key: "candidate_id"
  end
end
