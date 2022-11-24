class ChangedPriceToChildandadultPriceForActivitiesTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :price
    add_column :activities, :adult_price, :float, default: 0, null: false
    add_column :activities, :child_price, :float, default: 0, null: false
  end
end
