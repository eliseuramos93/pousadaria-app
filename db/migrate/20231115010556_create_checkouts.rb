class CreateCheckouts < ActiveRecord::Migration[7.1]
  def change
    create_table :checkouts do |t|
      t.references :reservation, null: false, foreign_key: true
      t.integer :payment_method, null: false

      t.timestamps
    end
  end
end
