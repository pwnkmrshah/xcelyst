class Industry < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.string :industry_name
      t.timestamps
    end
  end
end
