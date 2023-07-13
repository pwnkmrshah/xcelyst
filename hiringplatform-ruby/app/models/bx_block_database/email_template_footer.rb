class BxBlockDatabase::EmailTemplateFooter < ApplicationRecord
	self.table_name = :email_template_footers
  validate :only_one_enabled_footer, if: :enable?

  private

  def only_one_enabled_footer
    existing_enabled_footer = BxBlockDatabase::EmailTemplateFooter.find_by(enable: true)
    if existing_enabled_footer && existing_enabled_footer != self
      errors.add(:base, "Only one footer can be enabled at a time")
    end
  end
end
