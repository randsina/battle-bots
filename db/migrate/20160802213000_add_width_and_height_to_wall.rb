class AddWidthAndHeightToWall < ActiveRecord::Migration[5.0]
  def change
    add_column :walls, :width, :integer
    add_column :walls, :height, :integer
  end
end
