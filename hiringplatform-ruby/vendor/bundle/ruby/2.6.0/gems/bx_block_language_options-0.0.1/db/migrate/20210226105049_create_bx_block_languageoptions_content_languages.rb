class CreateBxBlockLanguageoptionsContentLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :contents_languages do |t|
      t.references :account, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
