class AddStatusToInns < ActiveRecord::Migration[7.1]
  def change
    add_column :inns, :status, :integer, default: 0
  end
end
