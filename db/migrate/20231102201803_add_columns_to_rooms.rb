class AddColumnsToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :has_bathroom, :boolean, default: false
    add_column :rooms, :has_balcony, :boolean, default: false
    add_column :rooms, :has_air_conditioner, :boolean, default: false
    add_column :rooms, :has_tv, :boolean, default: false
    add_column :rooms, :has_wardrobe, :boolean, default: false
    add_column :rooms, :has_vault, :boolean, default: false
    add_column :rooms, :is_accessible, :boolean, default: false
  end
end
