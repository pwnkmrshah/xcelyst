class Removecolumnfromexperiece < ActiveRecord::Migration[6.0]
  def change
    change_column :career_experiences, :add_key_achievements, :string, array: true,
                   default: [], using: "(string_to_array(add_key_achievements, ','))"
  end
end
