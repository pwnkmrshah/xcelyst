class AddLanguageIdInAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :app_language_id, :integer
  end
end
