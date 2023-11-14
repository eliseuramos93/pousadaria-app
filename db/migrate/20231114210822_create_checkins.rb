class CreateCheckins < ActiveRecord::Migration[7.1]
  def change
    create_table :checkins do |t|
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
