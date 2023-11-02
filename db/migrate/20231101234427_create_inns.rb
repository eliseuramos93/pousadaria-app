class CreateInns < ActiveRecord::Migration[7.1]
  def change
    create_table :inns do |t|
      t.references :user, null: false, foreign_key: true
      t.string :brand_name
      t.string :registration_number
      t.string :phone_number
      t.string :description
      t.boolean :pet_friendly
      t.string :policy
      t.time :checkin_time
      t.time :checkout_time

      t.timestamps
    end
  end
end
