class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums do |t|
      t.references :imageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
