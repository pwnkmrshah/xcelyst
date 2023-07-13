class BxBlockDatabase::EmailTemplateHeader < ApplicationRecord
	self.table_name = :email_template_headers
  validate :only_one_enabled_header, if: :enable?

  private

  def only_one_enabled_header
    existing_enabled_header = BxBlockDatabase::EmailTemplateHeader.find_by(enable: true)
    if existing_enabled_header && existing_enabled_header != self
      errors.add(:base, "Only one header can be enabled at a time")
    end
  end	
end
