class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :user, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.float :price
      t.integer :status, default: 0
      t.integer :number_guests

      t.timestamps
    end
  end
end
