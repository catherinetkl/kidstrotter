class RemovedPriceFromBookingsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :adult_price
    remove_column :bookings, :child_price
  end
end
