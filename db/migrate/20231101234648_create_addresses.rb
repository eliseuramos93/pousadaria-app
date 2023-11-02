class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :inn, null: false, foreign_key: true
      t.string :street_name
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end
