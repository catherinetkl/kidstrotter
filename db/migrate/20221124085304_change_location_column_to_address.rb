class ChangeLocationColumnToAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :activities, :location, :address
  end
end
