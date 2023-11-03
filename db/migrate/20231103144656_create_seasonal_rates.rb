class CreateSeasonalRates < ActiveRecord::Migration[7.1]
  def change
    create_table :seasonal_rates do |t|
      t.references :room, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.float :price

      t.timestamps
    end
  end
end
