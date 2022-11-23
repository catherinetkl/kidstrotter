class AddColumnAdultPriceChildPriceToBookingsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :adult_price, :float, default: 0, null: false
    add_column :bookings, :child_price, :float, default: 0, null: false
  end
end
