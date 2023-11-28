class CreateConsumables < ActiveRecord::Migration[7.1]
  def change
    create_table :consumables do |t|
      t.references :reservation, null: false, foreign_key: true
      t.string :description
      t.float :price

      t.timestamps
    end
  end
end
