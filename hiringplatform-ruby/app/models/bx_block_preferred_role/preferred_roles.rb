module BxBlockPreferredRole
    class PreferredRoles < BxBlockProfile::ApplicationRecord
      self.table_name = :preferred_roles
      validates :name, presence: true
    end
  end