class AddLocationsToMap < ActiveRecord::Migration[5.0]
  def change
    add_column :maps, :locations, :text
  end
end
