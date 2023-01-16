class CreateLiveStreams < ActiveRecord::Migration[6.0]
  def change
    create_table :live_streams do |t|
      t.string :headline
      t.string :description
      t.string :comment_section
      t.timestamps
    end
  end
end
