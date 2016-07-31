class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.json :value

      t.timestamps
    end
  end
end
