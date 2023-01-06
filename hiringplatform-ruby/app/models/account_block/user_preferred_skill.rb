module AccountBlock
  class UserPreferredSkill < ApplicationRecord
    self.table_name = :user_preferred_skills

    belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: 'account_id'
    belongs_to :preferred_skill, class_name: 'BxBlockPreferredRole::PreferredSkill', foreign_key: 'preferred_skill_id'
    
  end
end
