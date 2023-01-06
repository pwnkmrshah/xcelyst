class CreateBusinessDoamins < ActiveRecord::Migration[6.0]
  def change
    create_table :business_domains do |t|
    	t.string :name
        t.timestamps
    end
  end
end
